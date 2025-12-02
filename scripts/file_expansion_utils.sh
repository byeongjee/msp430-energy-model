#!/usr/bin/env bash
# Shared utility for file pattern expansion
# Supports: *.c, **/*.c, {a,b,c}.c, path/{dir1,dir2}/*.c
# Requires: bash 4.0+ (for mapfile)

# Helper function to expand file patterns (glob + brace expansion)
expand_file_input() {
    local input="$1"
    local files=()

    # Handle brace expansion manually
    # This function expands {a,b,c} patterns
    expand_braces() {
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
                expand_braces "${before}${item}${after}"
            done
        else
            echo "$pattern"
        fi
    }

    # First expand braces to get multiple patterns
    mapfile -t patterns < <(expand_braces "$input")

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

# Helper function to match files to CSVs by basename
# Usage: match_files_by_basename source_files_array csv_pattern_or_list [csv_type_description]
# Returns: matched CSV for each source file
# Exits with error if any match fails
match_files_by_basename() {
    local -n source_files_ref=$1
    local csv_input="$2"
    local csv_type="${3:-CSV}"  # Optional: description for error messages (e.g., "training raw CSV")

    # Match each source file to a CSV by basename
    local matched_csvs=()
    local failed_matches=()

    # Check if the pattern contains {filename} placeholder
    if [[ "$csv_input" == *"{filename}"* ]]; then
        # Pattern-based matching: substitute {filename} with each source basename
        for source_file in "${source_files_ref[@]}"; do
            local basename=$(basename "$source_file")
            basename="${basename%.c}"
            basename="${basename%.S}"
            # Substitute {filename} with the actual basename
            local csv_pattern="${csv_input//\{filename\}/$basename}"

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
                    echo "[WARNING] Multiple matches for $basename, using: ${expanded_files[0]}" >&2
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
            local basename=$(basename "$source_file")
            basename="${basename%.c}"
            basename="${basename%.S}"
            local matched_csv=""

            # Search for matching CSV
            if [[ ${#csv_pool[@]} -gt 0 ]]; then
                for csv in "${csv_pool[@]}"; do
                    local csv_basename=$(basename "$csv")
                    if [[ "$csv_basename" == *"$basename"* ]]; then
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
            local basename=$(basename "$file")
            basename="${basename%.c}"
            basename="${basename%.S}"
            echo "[WARNING]   - $basename" >&2
        done
    fi

    # Output matched CSVs (empty strings for files without matches)
    printf '%s\n' "${matched_csvs[@]}"
}

# Helper function to match a single file from a pattern
# Usage: match_single_file csv_pattern [csv_type_description]
# Returns: the single matched file path
# Exits with error if 0 or more than 1 file is matched
match_single_file() {
    local csv_input="$1"
    local csv_type="${2:-CSV}"  # Optional: description for error messages (e.g., "test segments CSV")

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
