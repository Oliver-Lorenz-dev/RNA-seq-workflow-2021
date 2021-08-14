# script to make a shell script for downloading data from the SRA
import sys
f = sys.argv[1]
import in_place
import os

# add wget to all lines in file
def add_wget(file):
    with in_place.InPlace(file) as file:
        for line in file:
            if line.startswith("wget"):
                line = line
                file.write(line)
            elif line.startswith("#!/usr/bin/bash"):
                line = line
                file.write(line)
            else:
                line = "wget " + line
                file.write(line)

# add bash script flag to start of file
def add_bash(file):
    location = "./"
    path_original = os.path.join(location,file)
    temp = "ebi_urls_temp.txt"
    path_temp = os.path.join(location, temp)
    if  os.path.exists(path_temp):
        os.remove("ebi_urls_temp.txt")
    with open(file, "r") as file:
       with open("ebi_urls_temp.txt", "w") as temp_file:
           temp_file.write("#!/usr/bin/bash\n")
           temp_file.write(file.read())
    os.remove(path_original)
    os.rename(path_temp, "data_downloader.sh")

add_wget(f)
add_bash(f)
