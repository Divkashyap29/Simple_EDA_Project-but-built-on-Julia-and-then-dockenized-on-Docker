FROM julia:1.10-bullseye

# Minimal libs so GR/StatsPlots can save PNGs headlessly
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx libxrender1 libxext6 libxt6 libgomp1 fontconfig \
 && rm -rf /var/lib/apt/lists/*

ENV GKSwstype=100
WORKDIR /app

# Copy your code & data
COPY . /app

# Ensure registry + install the *exact* packages you use
RUN julia --color=yes -e "using Pkg; \
    try Pkg.Registry.add(\"General\") catch; end; \
    try Pkg.Registry.add(Pkg.RegistrySpec(url=\"https://github.com/JuliaRegistries/General.git\")) catch; end; \
    Pkg.add.( [\"CSV\",\"DataFrames\",\"StatsPlots\",\"GLM\",\"CategoricalArrays\"] ); \
    Pkg.precompile()"

# Run your script with this folder as the active project
CMD ["julia","--color=yes","--project=/app","EDA_Project1.jl"]

