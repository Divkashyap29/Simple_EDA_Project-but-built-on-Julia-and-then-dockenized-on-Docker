using Pkg, Dates

# Activate your project explicitly
Pkg.activate("/app"; shared=false)

# Make sure the General registry is present
try
    Pkg.Registry.add("General")
catch err
    @warn "Registry add failed" err
end

# Remove problematic packages (ignore if they aren't present)
for p in ["JSON","Plots","StatsPlots"]
    try
        @info "Removing package" p
        Pkg.rm(p)
    catch err
        @warn "Could not remove (maybe not installed)" p err
    end
end

# Resolve deps and garbage-collect (remove unused stuff immediately)
Pkg.resolve()
Pkg.gc(; collect_delay=Day(0))

# Nuke compiled caches to avoid stale precompile issues
depot = first(DEPOT_PATH)
compiled_dir = joinpath(depot, "compiled", "v$(VERSION.major).$(VERSION.minor)")
if isdir(compiled_dir)
    println("🧹 Removing compiled caches in: $compiled_dir")
    rm(compiled_dir; force=true, recursive=true)
end

# Re-precompile remaining packages in your project (keeps core deps)
Pkg.precompile()

println("✅ Cleanup done. JSON/Plots/StatsPlots removed, caches reset, project precompiled.")
