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

<img width="1106" height="877" alt="image" src="https://github.com/user-attachments/assets/6bad6bcf-ae13-4efa-a222-ba9064148082" />


 Plotting yearly tsunami rate on Plot Chart ...
 Saved: yearly_tsunami_rate.png 
        what do we understand from the plot?
        The Yearly Tsunami Rate chart shows that from 2000 to 2010, almost no earthquakes in the dataset were linked to tsunamis, but after 2011, the rate suddenly increased to around 60–80%. This sharp jump likely reflects the impact of the 2011 Tōhoku earthquake in Japan, which caused a major tsunami and marked a shift in how such events were recorded globally. The consistently high rates after 2011 may indicate improved tsunami detection and reporting rather than an actual rise in tsunami occurrences. Overall, the trend suggests a significant change in data quality and coverage post-2011, emphasizing that the observed increase is more about better recording practices than a real surge in tsunami activity.
 saved heatmap_mag_depth.png
 saved heatmap_spatial.png
        The spatial heatmap reveals that tsunami occurrences are not evenly distributed across the globe. Instead, they are concentrated in specific regions, particularly along the Pacific Ring of Fire, which is known for its high seismic activity. Areas such as the coasts of Japan, Indonesia, and the western Americas show higher tsunami rates, indicating a greater risk in these zones. This uneven distribution highlights the importance of regional preparedness and monitoring in areas prone to earthquakes and tsunamis. Overall, the map underscores that tsunami risk is highly location-dependent, necessitating targeted mitigation strategies in vulnerable coastal regions.
 Trying Logistic Regression for our model
 Training our logistic regression model...
<img width="937" height="238" alt="image" src="https://github.com/user-attachments/assets/a7805df5-c2b2-4f6d-ba0b-bd9d4c4ab35a" />

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
    
