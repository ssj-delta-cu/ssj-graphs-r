# loads geojson files a data frame and save it to a rds
source("scripts/helper_functions.R")

list_of_files <- list.files(path="data/full_20170509", pattern=".geojson", full.names=TRUE)
# files shoulds be named "data/model-region-wy.json"

# for loop to load in all the raw json files to single data frame
load_json <- function(file_list) {
  
  listofdfs <- list() #Create a list in which you intend to save your df's.
  
  for (i in 1:length(file_list)) {
    f <- file_list[i]
    print(f)
    p <- strsplit(f, split="[-./]")[[1]]
    method <- p[3]
    region <- p[4]
    wy <- as.integer(p[5])
    print(method)
    print(region)
    print(wy)
    d <- ee_geojson_properties_2_df(f, method, region, wy, 200)
    listofdfs[[i]]<-d
  }
  df <- ldply(listofdfs, data.frame) # make into one dataframe 
}

data <- load_json(list_of_files)
saveRDS(data, file="data/full_20170509/data_both_wy_20170509_v2.rds")