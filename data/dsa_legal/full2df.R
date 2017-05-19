# loads geojson files a data frame and save it to a rds
source("scripts/helper_functions.R")

list_of_files <- list.files(path="data/dsa_legal", pattern=".geojson", full.names=TRUE)
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
    d <- ee_geojson_properties_2_df(f, method, region, wy, 30)
    listofdfs[[i]]<-d
  }
  df <- ldply(listofdfs, data.frame) # make into one dataframe 
}

data <- load_json(list_of_files)
saveRDS(data, file="data/dsa_legal/dsa_legal_5methods_20170519.rds")