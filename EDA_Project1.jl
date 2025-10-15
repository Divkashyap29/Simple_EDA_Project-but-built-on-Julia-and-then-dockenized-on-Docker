###############################################################
# Earthquake–Tsunami Risk Assessment (EDA)
# Author: Divyanshi Kashyap
# Description: Exploratory analysis of earthquake and tsunami data
###############################################################

using CSV, DataFrames, StatsPlots, GLM, Random, Statistics, CategoricalArrays



df = CSV.read("earthquake_data_tsunami.csv", DataFrame)
println("Shape of data: ", size(df))
println("Column names: ", names(df))

println("\n Removing duplicates")
unique_cols = [:Year, :Month, :latitude, :longitude, :magnitude, :depth]
df = unique(df, unique_cols)
println("Rows after removing duplicates: ", nrow(df))


println("\n Dropping missing values")
df = dropmissing(df)
println("Rows after removing missing values: ", nrow(df))


println("\nSummary Statistics:")
describe(df) |> println


if eltype(df.tsunami) <: Bool
    df.tsunami = Int.(df.tsunami)                  # true->1, false->0
elseif eltype(df.tsunami) <: AbstractString
    df.tsunami = parse.(Int, strip.(df.tsunami))   # "1"/"0" -> 1/0
elseif eltype(df.tsunami) <: Number
    df.tsunami = Int.(df.tsunami .> 0)             # any nonzero -> 1
else
    error("Unsupported tsunami type: $(eltype(df.tsunami))")
end

# Now compute yearly totals and tsunami counts
yearly = combine(
    groupby(df, :Year),
    nrow => :total,
    :tsunami => sum => :tsunami_count,             # sums 1s (since 0/1)
)

yearly.Tsunami_Rate = yearly.tsunami_count ./ yearly.total
println(first(yearly, 22))


println(" Plotting yearly tsunami rate on Plot Chart ...")
gr()
plot(yearly.Year, yearly.Tsunami_Rate,
     title = "Yearly Tsunami Rate",
     xlabel = "Year",
     ylabel = "Tsunami Rate",
     legend = false)
savefig("yearly_tsunami_rate.png")
println(" Saved: yearly_tsunami_rate.png 
        what do we understand from the plot? 
        The Yearly Tsunami Rate chart shows that from 2000 to 2010, almost no earthquakes in the dataset were linked to tsunamis, but after 2011, the rate suddenly increased to around 60–80%. This sharp jump likely reflects the impact of the 2011 Tōhoku earthquake in Japan, which caused a major tsunami and marked a shift in how such events were recorded globally. The consistently high rates after 2011 may indicate improved tsunami detection and reporting rather than an actual rise in tsunami occurrences. Overall, the trend suggests a significant change in data quality and coverage post-2011, emphasizing that the observed increase is more about better recording practices than a real surge in tsunami activity. ")

# bins (tweak if you like)
mag_edges   = collect(4.0:0.5:9.5)
depth_edges = [0, 10, 30, 70, 150, 300, 700]

# bin columns
df.mag_bin   = cut(df.magnitude, mag_edges; extend=true)
df.depth_bin = cut(df.depth,     depth_edges; extend=true)

# lock ordered levels for stable axes
mag_lvls   = levels(df.mag_bin)
depth_lvls = levels(df.depth_bin)
df.mag_bin   = categorical(df.mag_bin;   ordered=true, levels=mag_lvls)
df.depth_bin = categorical(df.depth_bin; ordered=true, levels=depth_lvls)

# tsunami rate per (mag, depth)
grouped = combine(groupby(df, [:mag_bin, :depth_bin]),
                  :tsunami => (x -> mean(skipmissing(Float64.(x)))) => :rate)

# build full grid to avoid shape errors
grid = DataFrame(
  mag_bin   = CategoricalArray(repeat(mag_lvls, inner=length(depth_lvls)); ordered=true, levels=mag_lvls),
  depth_bin = CategoricalArray(vcat([fill(d, length(mag_lvls)) for d in depth_lvls]...); ordered=true, levels=depth_lvls)
)
grid = leftjoin(grid, grouped, on=[:mag_bin, :depth_bin])

# Z matrix (rows=depth, cols=mag)
Z = Array{Float64}(undef, length(depth_lvls), length(mag_lvls))
for (i,d) in enumerate(depth_lvls), (j,m) in enumerate(mag_lvls)
    v = grid.rate[(grid.depth_bin .== d) .& (grid.mag_bin .== m)]
    Z[i,j] = (isempty(v) || ismissing(v[1])) ? NaN : v[1]
end

# plot
heatmap(1:length(mag_lvls), 1:length(depth_lvls), Z,
        xlabel="Magnitude bin", ylabel="Depth bin (km)",
        colorbar_title="Tsunami rate",
        title="Tsunami Rate by Magnitude × Depth",
        size=(900,520))
xticks!(1:length(mag_lvls), String.(mag_lvls))
yticks!(1:length(depth_lvls), String.(depth_lvls))
savefig("heatmap_mag_depth.png")
println(" saved heatmap_mag_depth.png")



step = 2.0  # grid size in degrees (e.g., 2° × 2°)
df.lat_bin = floor.(df.latitude  ./ step) .* step
df.lon_bin = floor.(df.longitude ./ step) .* step

sp = combine(groupby(df, [:lat_bin, :lon_bin]),
             nrow => :total,
             :tsunami => (x -> sum(skipmissing(Int.(x)))) => :tsunami_count)
sp.tsunami_rate = sp.tsunami_count ./ sp.total

# show as colored points at cell centers
scatter(sp.lon_bin .+ step/2, sp.lat_bin .+ step/2,
        zcolor=sp.tsunami_rate, markersize=6, markerstrokewidth=0,
        xlabel="Longitude", ylabel="Latitude",
        colorbar_title="Tsunami rate",
        title="Coarse Spatial Tsunami Rate (grid=$(step)°)")
savefig("heatmap_spatial.png")
println(" saved heatmap_spatial.png
        The spatial heatmap reveals that tsunami occurrences are not evenly distributed across the globe. Instead, they are concentrated in specific regions, particularly along the Pacific Ring of Fire, which is known for its high seismic activity. Areas such as the coasts of Japan, Indonesia, and the western Americas show higher tsunami rates, indicating a greater risk in these zones. This uneven distribution highlights the importance of regional preparedness and monitoring in areas prone to earthquakes and tsunamis. Overall, the map underscores that tsunami risk is highly location-dependent, necessitating targeted mitigation strategies in vulnerable coastal regions.")



println(" Trying Logistic Regression for our model ")
select_features = [:magnitude, :depth, :latitude, :longitude]
df_model = df[:, [select_features; :tsunami]]



Random.seed!(123)
n = nrow(df_model)
shuffle_idx = shuffle(1:n)
split_point = Int(round(0.7 * n))
train_idx = shuffle_idx[1:split_point]
test_idx  = shuffle_idx[split_point+1:end]
train = df_model[train_idx, :]
test  = df_model[test_idx, :]


println(" Training our logistic regression model...")
model = glm(@formula(tsunami ~ magnitude + depth + latitude + longitude),
            train, Binomial(), LogitLink())
println(coeftable(model))



test_pred = predict(model, test)
test_pred_class = test_pred .> 0.5
accuracy = mean((test_pred_class .== test.tsunami))
println(" Accuracy on test data: ", round(accuracy * 100, digits=2), "%")


println("\nPlotting magnitude vs depth scatter plot...")
scatter(df.magnitude, df.depth,
        group=df.tsunami,
        title="Magnitude vs Depth (Tsunami=1, No Tsunami=0)",
        xlabel="Magnitude",
        ylabel="Depth (km)",
        legend=:topleft)
savefig("magnitude_depth_scatter.png")
println("Saved: magnitude_depth_scatter.png")


###############################################################
