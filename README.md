# Simple_EDA_Project-but-built-on-Julia-and-then-dockenized-on-Docker


It's like really reeally simpls EDA but this is built on Julia Pogramming language and then later i wanted to use docker do used it to dockenize it 

###############################################################
# Earthquake–Tsunami Risk Assessment (EDA)
# Author: Divyanshi Kashyap
# Description: Exploratory analysis of earthquake and tsunami data
###############################################################

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


Onw of the  most important thing to understand is that this is Julia not pythong you don't import pandas or any other studd 
but you do ofc bring packages and use them accordingly 


using CSV, DataFrames, StatsPlots, GLM, Random, Statistics, CategoricalArrays
nd here CSV is basically read_csv, statsplots is bascially equivalent to matplotlib, CategorialArrays is Equialvant to Numpy which gets used in pandas 

model i made was very basic becuase honestly i wanted to work more on making julia into docker conAtainer, which stills needs to worked on my whateevr 
so yeah i wrote code and whatever than 
I got ouput genertaed as 
#####################################################################################################################
data set used though? 
import kagglehub

# Download latest version
path = kagglehub.dataset_download("ahmeduzaki/global-earthquake-tsunami-risk-assessment-dataset")

print("Path to dataset files:", path)
####################################################################################################################

OUTPUT GENERATED 
Shape of data: (782, 13)
Column names: ["magnitude", "cdi", "mmi", "sig", "nst", "dmin", "gap", "depth", "latitude", "longitude", "Year", "Month", "tsunami"]

 Removing duplicates
Rows after removing duplicates: 780

 Dropping missing values
Rows after removing missing values: 780

Summary Statistics:
13×7 DataFrame
 Row │ variable   mean         min        median     max        nmissing  eltype   
     │ Symbol     Float64      Real       Float64    Real       Int64     DataType
─────┼─────────────────────────────────────────────────────────────────────────────
   1 │ magnitude     6.942        6.5        6.8        9.1            0  Float64
   2 │ cdi           4.34487      0          5.0        9              0  Int64
   3 │ mmi           5.97051      1          6.0        9              0  Int64
   4 │ sig         870.621      650        754.0     2910              0  Int64
   5 │ nst         230.786        0        141.5      934              0  Int64
   6 │ dmin          1.32916      0.0        0.0       17.654          0  Float64
   7 │ gap          24.5724       0.0       20.0      239.0            0  Float64
   8 │ depth        75.988        2.7       26.0      670.81           0  Float64
   9 │ latitude      3.41258    -61.8484    -2.6268    71.6312         0  Float64
  10 │ longitude    53.1746    -179.968    113.558    179.662          0  Float64
  11 │ Year       2012.26      2001       2013.0     2022              0  Int64
  12 │ Month         6.57821      1          7.0       12              0  Int64
  13 │ tsunami       0.387179     0          0.0        1              0  Int64
22×4 DataFrame
 Row │ Year   total  tsunami_count  Tsunami_Rate 
     │ Int64  Int64  Int64          Float64
─────┼───────────────────────────────────────────
   1 │  2001     28              0      0.0
   2 │  2002     25              0      0.0
   3 │  2003     31              0      0.0
   4 │  2004     32              0      0.0
   5 │  2005     28              0      0.0
   6 │  2006     26              0      0.0
   7 │  2007     37              0      0.0
   8 │  2008     25              0      0.0
   9 │  2009     26              0      0.0
  10 │  2010     41              0      0.0
  11 │  2011     34              0      0.0
  12 │  2012     31              0      0.0
  13 │  2013     53             34      0.641509
  14 │  2014     48             40      0.833333
  15 │  2015     53             33      0.622642
  16 │  2016     43             31      0.72093
  17 │  2017     36             27      0.75
  18 │  2018     43             33      0.767442
  19 │  2019     33             26      0.787879
  20 │  2020     27             15      0.555556
  21 │  2021     42             33      0.785714
  22 │  2022     38             30      0.789474
 Plotting yearly tsunami rate on Plot Chart ...
 Saved: yearly_tsunami_rate.png 
        what do we understand from the plot?
        The Yearly Tsunami Rate chart shows that from 2000 to 2010, almost no earthquakes in the dataset were linked to tsunamis, but after 2011, the rate suddenly increased to around 60–80%. This sharp jump likely reflects the impact of the 2011 Tōhoku earthquake in Japan, which caused a major tsunami and marked a shift in how such events were recorded globally. The consistently high rates after 2011 may indicate improved tsunami detection and reporting rather than an actual rise in tsunami occurrences. Overall, the trend suggests a significant change in data quality and coverage post-2011, emphasizing that the observed increase is more about better recording practices than a real surge in tsunami activity.
 saved heatmap_mag_depth.png
 saved heatmap_spatial.png
        The spatial heatmap reveals that tsunami occurrences are not evenly distributed across the globe. Instead, they are concentrated in specific regions, particularly along the Pacific Ring of Fire, which is known for its high seismic activity. Areas such as the coasts of Japan, Indonesia, and the western Americas show higher tsunami rates, indicating a greater risk in these zones. This uneven distribution highlights the importance of regional preparedness and monitoring in areas prone to earthquakes and tsunamis. Overall, the map underscores that tsunami risk is highly location-dependent, necessitating targeted mitigation strategies in vulnerable coastal regions.
 Trying Logistic Regression for our model
 Training our logistic regression model...
─────────────────────────────────────────────────────────────────────────────────
                   Coef.   Std. Error      z  Pr(>|z|)     Lower 95%    Upper 95%
─────────────────────────────────────────────────────────────────────────────────
(Intercept)  -0.798808    1.38937      -0.57    0.5653  -3.52193       1.92431
magnitude     0.0416569   0.199642      0.21    0.8347  -0.349634      0.432948
depth         0.00050262  0.000613371   0.82    0.4125  -0.000699565   0.0017048
latitude     -0.00862085  0.00334883   -2.57    0.0100  -0.0151844    -0.00205727
longitude    -0.00150802  0.000755011  -2.00    0.0458  -0.00298781   -2.82229e-5
─────────────────────────────────────────────────────────────────────────────────
 Accuracy on test data: 59.4%

Plotting magnitude vs depth scatter plot...
Saved: magnitude_depth_scatter.png 


####################################################################################################################################


okay so starting with dockerization
we are supposed to create a docker image but before that 
we need to put a docker file like below and write a script which would help our docker to understand exactly how to get enviornmnet andd set tit up 
<img width="1277" height="716" alt="image" src="https://github.com/user-attachments/assets/7c36af58-fec2-4db5-83b8-da1bfedf3818" />
and now this was not at all easy becuase formal layout of docker files is quite different than formal code used for specially Julia 

FROM <image>	Defines a base for your image.
RUN <command>	Executes any commands in a new layer on top of the current image and commits the result. RUN also has a shell form for running commands.
WORKDIR <directory>	Sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that follow it in the Dockerfile.
COPY <src> <dest>	Copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.
CMD <command>	Lets you define the default program that is run once you start the container based on this image. Each Dockerfile only has one CMD, and only the last CMD instance is respected when multiple exist.

but here because we are using julia and i  did firstly everything with basic layout, but even after trying n number times i was not able to complie packgaes by Julie in docker 
so i ended up changing and added packages to dockerfile code also to make docker understand that i WANT PACKAGESSS ALSOOO 
code tuned out to be something like this 
RUN julia --color=yes -e "using Pkg; \
    try Pkg.Registry.add(\"General\") catch; end; \
    try Pkg.Registry.add(Pkg.RegistrySpec(url=\"https://github.com/JuliaRegistries/General.git\")) catch; end; \
    Pkg.add.( [\"CSV\",\"DataFrames\",\"StatsPlots\",\"GLM\",\"CategoricalArrays\"] ); \
    Pkg.precompile()"

    but anyways we also have a Porject,toml file where we have name of allpackages required for our juila language and to run it 
    <img width="736" height="382" alt="image" src="https://github.com/user-attachments/assets/cf7c74a4-3a7d-4346-9cea-c14b31cde098" />

    so i made a docker image using commond :- docker build --no-cache -t edadocker . 
    this edadocker is name of my image  here 

    then i put a commond to make a docker container :- docker run --rm -v "${PWD}:/app" edadocker

    this is exactly where things got messed up 
    becuase it showed me wrror that CategoricalArrays is not installed or something like that 
which just didn't make sense beucase i used it to get plots 
for a sec i thought my scipt is wrong, i changed it countless time 
just like why is this thing not working 
it showed me ehat it is not instaintaing and stuff, when i tried it again failes 
so at end i endup rmeoving that library from whole thing then i again added it
it did work 
but there some more issues with GB, Plots libraries 
i was like commmon bro it is soooo bad, i am so tired 

so maybe i am gonnna use now  https://words.yuvi.in/post/pre-compiling-julia-docker/ 
and few more links i am finding to successfully complie 
    
