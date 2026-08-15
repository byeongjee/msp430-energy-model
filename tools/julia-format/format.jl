using Pkg

# JuliaFormatter lives in this directory's own environment so that formatting
# does not instantiate the whole project (Plots, Gen, JuMP, ...).
Pkg.activate(@__DIR__; io = devnull)
Pkg.instantiate(; io = devnull)

using JuliaFormatter

const PROJECT_ROOT = dirname(dirname(@__DIR__))
const SOURCE_DIRS = ["src", "test"]

function julia_files()
    paths = String[]
    for dir in SOURCE_DIRS,
        (root, _, files) in walkdir(joinpath(PROJECT_ROOT, dir)),
        file in files

        endswith(file, ".jl") && push!(paths, joinpath(root, file))
    end
    return sort(paths)
end

check = "--check" in ARGS
unformatted = filter(path -> !format(path; overwrite = !check), julia_files())

if !isempty(unformatted)
    if check
        println(stderr, "Julia sources need formatting:")
        foreach(path -> println(stderr, "  ", relpath(path, PROJECT_ROOT)), unformatted)
        println(stderr, "Run: julia tools/julia-format/format.jl")
        exit(1)
    end
    println("Formatted ", length(unformatted), " Julia files")
end
