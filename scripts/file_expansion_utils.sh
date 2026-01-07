#!/usr/bin/env bash
# Shared utility for file pattern expansion
# Supports: *.c, **/*.c, {a,b,c}.c, path/{dir1,dir2}/*.c
# Requires: bash 4.0+ (for mapfile)

# ============================================================
# INTERNAL HELPER FUNCTIONS
# ============================================================

# _expand_braces PATTERN
#
# Internal helper to recursively expand brace patterns like {a,b,c}.
# Handles nested braces by processing one level at a time.
#
# Arguments:
#   PATTERN - Pattern containing {a,b,c} brace expansion
#
# Outputs:
#   One line per expanded pattern to stdout
#
# Example:
#   _expand_braces "test/{a,b}.c"
#   # Outputs:
#   # test/a.c
#   # test/b.c
_expand_braces() {
    local pattern="$1"

    # Check if pattern contains braces
    if [[ "$pattern" =~ \{[^}]+\} ]]; then
        # Extract the brace content
        local before="${pattern%%\{*}"
        local brace_content="${pattern#*\{}"
        brace_content="${brace_content%%\}*}"
        local after="${pattern#*\}}"

        # Split by comma and expand each
        IFS=',' read -ra items <<< "$brace_content"
        for item in "${items[@]}"; do
            _expand_braces "${before}${item}${after}"
        done
    else
        echo "$pattern"
    fi
}

# _get_file_basename FILE
#
# Internal helper to extract basename without .c or .S extension.
# Used by match_files_by_basename.
#
# Arguments:
#   FILE - Path to file
#
# Outputs:
#   Basename without extension to stdout
_get_file_basename() {
    local file="$1"
    local base
    base=$(basename "$file")
    base="${base%.c}"
    base="${base%.S}"
    echo "$base"
}

# ============================================================
# PUBLIC FUNCTIONS
# ============================================================

# expand_file_input INPUT
#
# Expand file patterns supporting glob, recursive glob, and brace expansion.
#
# Supported patterns:
#   - Literal file path: "examples/simple.c"
#   - Glob patterns: "examples/*.c", "examples/test?.c"
#   - Recursive glob: "examples/**/*.c"
#   - Brace expansion: "examples/{a,b,c}.c"
#   - Combined: "examples/{foo,bar}/**/*.c"
#
# Arguments:
#   INPUT - File pattern to expand
#
# Outputs:
#   One file path per line to stdout, sorted and deduplicated
#
# Returns:
#   0 on success (even if no files match)
#
# Example:
#   mapfile -t files < <(expand_file_input "examples/**/*.c")
expand_file_input() {
    local input="$1"
    local files=()

    # First expand braces to get multiple patterns
    mapfile -t patterns < <(_expand_braces "$input")

    # Now expand each pattern with glob/find
    for pattern in "${patterns[@]}"; do
        # Handle ** (recursive glob) with find
        if [[ "$pattern" == *"**"* ]]; then
            # Split on **
            local prefix="${pattern%%\*\**}"
            local suffix="${pattern#*\*\*}"
            suffix="${suffix#/}" # Remove leading slash if present

            # Use find for recursive search
            if [[ -n "$suffix" ]]; then
                while IFS= read -r -d '' file; do
                    files+=("$file")
                done < <(find "$prefix" -type f -path "*$suffix" -print0 2>/dev/null)
            else
                while IFS= read -r -d '' file; do
                    files+=("$file")
                done < <(find "$prefix" -type f -print0 2>/dev/null)
            fi
        # Handle regular glob patterns (*, ?)
        elif [[ "$pattern" == *"*"* ]] || [[ "$pattern" == *"?"* ]]; then
            # Use bash glob expansion
            shopt -s nullglob
            local expanded=($pattern)
            shopt -u nullglob

            for file in "${expanded[@]}"; do
                [[ -f "$file" ]] && files+=("$file")
            done
        else
            # Literal filename
            [[ -f "$pattern" ]] && files+=("$pattern")
        fi
    done

    # Remove duplicates and sort
    if [[ ${#files[@]} -gt 0 ]]; then
        printf '%s\n' "${files[@]}" | sort -u
    fi
}

# match_files_by_basename SOURCE_ARRAY CSV_PATTERN [CSV_TYPE]
#
# Match source files to CSV files by basename.
#
# Supports two matching modes:
#   1. {filename} placeholder: Pattern like "tmp/{filename}_segments.csv"
#      substitutes {filename} with each source basename
#   2. Pool matching: Glob pattern or semicolon-separated list, matches
#      CSV files containing the source basename as a substring
#
# Arguments:
#   SOURCE_ARRAY - Name of array variable containing source file paths
#   CSV_PATTERN  - Pattern or list of CSV files to match against
#   CSV_TYPE     - (Optional) Description for error messages (default: "CSV")
#
# Outputs:
#   One matched CSV path per source file (empty string if no match)
#   Warnings to stderr for unmatched files
#
# Returns:
#   0 on success (unmatched files produce warnings, not errors)
#
# Example:
#   source_files=("a.c" "b.c")
#   mapfile -t csvs < <(match_files_by_basename source_files "tmp/*_segments.csv")
match_files_by_basename() {
    local -n source_files_ref=$1
    local csv_input="$2"
    local csv_type="${3:-CSV}"

    local matched_csvs=()
    local failed_matches=()

    # Check if the pattern contains {filename} placeholder
    if [[ "$csv_input" == *"{filename}"* ]]; then
        # Pattern-based matching: substitute {filename} with each source basename
        for source_file in "${source_files_ref[@]}"; do
            local base
            base=$(_get_file_basename "$source_file")

            # Substitute {filename} with the actual basename
            local csv_pattern="${csv_input//\{filename\}/$base}"

            # Expand the pattern (may contain wildcards)
            local expanded_files=()
            shopt -s nullglob
            expanded_files=($csv_pattern)
            shopt -u nullglob

            # Check if any files matched
            if [[ ${#expanded_files[@]} -gt 0 ]]; then
                # Use the first match if multiple files found
                matched_csvs+=("${expanded_files[0]}")
                if [[ ${#expanded_files[@]} -gt 1 ]]; then
                    echo "[WARNING] Multiple matches for $base, using: ${expanded_files[0]}" >&2
                fi
            else
                matched_csvs+=("")
                failed_matches+=("$source_file")
            fi
        done
    else
        # Legacy behavior: Build pool of CSV files and match by substring
        local csv_pool=()
        if [[ -n "$csv_input" ]]; then
            # Check if semicolon-separated or glob pattern
            if [[ "$csv_input" == *";"* ]]; then
                # Parse semicolon-separated list
                IFS=';' read -ra csv_pool <<< "$csv_input"
            else
                # Expand glob pattern
                mapfile -t csv_pool < <(expand_file_input "$csv_input")
            fi
        fi

        for source_file in "${source_files_ref[@]}"; do
            local base
            base=$(_get_file_basename "$source_file")
            local matched_csv=""

            # Search for matching CSV
            if [[ ${#csv_pool[@]} -gt 0 ]]; then
                for csv in "${csv_pool[@]}"; do
                    local csv_basename
                    csv_basename=$(basename "$csv")
                    if [[ "$csv_basename" == *"$base"* ]]; then
                        matched_csv="$csv"
                        break
                    fi
                done
            fi

            # Track results
            if [[ -z "$matched_csv" ]]; then
                failed_matches+=("$source_file")
            fi
            matched_csvs+=("$matched_csv")
        done
    fi

    # Report failed matches as warnings (not errors - files may not have CSVs yet)
    if [[ ${#failed_matches[@]} -gt 0 ]]; then
        echo "[WARNING] No matching $csv_type files found for ${#failed_matches[@]} source file(s) (will be measured):" >&2
        for file in "${failed_matches[@]}"; do
            local base
            base=$(_get_file_basename "$file")
            echo "[WARNING]   - $base" >&2
        done
    fi

    # Output matched CSVs (empty strings for files without matches)
    printf '%s\n' "${matched_csvs[@]}"
}

# match_single_file CSV_PATTERN [CSV_TYPE]
#
# Match exactly one file from a pattern.
#
# Arguments:
#   CSV_PATTERN - Pattern that should match exactly one file
#   CSV_TYPE    - (Optional) Description for error messages (default: "CSV")
#
# Outputs:
#   The single matched file path to stdout
#
# Returns:
#   0 on success
#   1 on error (0 or >1 matches), exits with error
#
# Example:
#   csv_file=$(match_single_file "tmp/test_segments.csv" "test segments CSV")
match_single_file() {
    local csv_input="$1"
    local csv_type="${2:-CSV}"

    # Expand the pattern
    local csv_pool=()
    mapfile -t csv_pool < <(expand_file_input "$csv_input")

    # Validate: expect exactly 1 match
    if [[ ${#csv_pool[@]} -eq 0 ]]; then
        echo "[ERROR] No $csv_type files found for pattern: $csv_input" >&2
        exit 1
    elif [[ ${#csv_pool[@]} -gt 1 ]]; then
        echo "[ERROR] Expected exactly 1 $csv_type file, but found ${#csv_pool[@]} matches for pattern: $csv_input" >&2
        echo "[ERROR] Matched files:" >&2
        for file in "${csv_pool[@]}"; do
            echo "[ERROR]   - $file" >&2
        done
        exit 1
    fi

    # Output the single matched file
    echo "${csv_pool[0]}"
}
