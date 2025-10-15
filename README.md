# Simple_EDA_Project-but-built-on-Julia-and-then-dockenized-on-Docker


It's like really reeally simpls EDA but this is built on Julia Pogramming language and then later i wanted to use docker do used it to dockenize it 


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
    
