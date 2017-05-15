# loads geojson file from the island sub-regions into a data frame and save it to a rds
source("scripts/subregion_geojson_cleanup.R")

list_of_files <- list.files(path="data/subregions", pattern=".geojson", full.names=TRUE)

# for loop to load in all the raw json files to single data frame
load_json <- function(file_list) {
  
  listofdfs <- list() #Create a list in which you intend to save your df's.
  
  for (i in 1:length(file_list)) {
    print(file_list[i])
    g <- add_fields(file_list[i])
    listofdfs[[i]]<-g
  }
  df <- ldply(listofdfs, data.frame) # make into one dataframe 
}

data <- load_json(list_of_files)
saveRDS(data, file="data/subregions/subregions_20170509.rds")
