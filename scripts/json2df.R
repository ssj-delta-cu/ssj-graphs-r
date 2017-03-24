# json2df to process json results into a pretty r data frame

if(!require(rjson)){
  install.packages("rjson")
  library(rjson)
}

if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}

# load the crop id name table
crops <- read.csv('data/crops.csv', stringsAsFactors=FALSE)

# load the months
months <- read.csv('data/months.csv', stringsAsFactors=FALSE)

ee_json_2_df <-function(json, model, aoi, wy){
  # where json = path to json with results, model = model group name, aoi = region of the results, wy=water year
  lists_dfs_by_month <- fromJSON(json)
  df <- ldply(lists_dfs_by_month, data.frame) # make into one dataframe
  names(df)[names(df) == '.id'] <- 'month' # renames name of individual df column
  df$model <- model
  df$region <- aoi
  df$wateryear <- wy
  df$source <- json
  
  # crop lookups
  df <- mutate(df, cropname=lookup_cropname(level_2)) # add cropname from Crops.csv lookup
  df <- mutate(df, include=lookup_include(level_2)) # add crop include from Crops.csv lookup
  
  # add number days in month
  df <- mutate(df, num_days=num_days_in_month(wateryear, month))
  
  # calculate crop et acre feet
  df <- mutate(df, crop_acft=crop_acre_feet(mean, count, num_days))
  return(df)
}

lookup_cropname <- function(id){
  cropname = crops$Commodity[match(id, crops$Number)]
  return(cropname)
}

lookup_include <- function(id){
  include = crops$Include[match(id, crops$Number)]
  return(include)
}

num_days_in_month <- function(wy, month){
  wateryr <- mutate(months, cmb=paste(months$WaterYear, months$Month))
  days <- wateryr$NumberDays[match(paste(wy, month), wateryr$cmb)]
  return(days)
}

crop_acre_feet <- function(mean_et, cell_count, number_days){
  # Crop_acre_feet = (count) * (reducer pixel size) ^2 * (sq m to acres) * (mean daily ET) /10* (mm to feet) * (num days in month)
  reducer_size <- 200
  mm2ft <- 0.00328084
  sqm2acres <- 0.000247105
  crop_acft <- cell_count * reducer_size^2 * sqm2acres * mean_et / 10 * mm2ft * number_days 
  return(crop_acft)
}



##################################################################################

list_of_files <- list.files(path="data/", pattern=".json", full.names=TRUE)


# for loop to load in all the raw json files to single data frame
load_json <- function(file_list) {

  listofdfs <- list() #Create a list in which you intend to save your df's.
  
  for (i in 1:length(file_list)) {
    f <- file_list[i]
    print(f)
    p <- strsplit(f, split="[-./]")[[1]]
    method <- p[2]
    region <- p[3]
    wy <- as.integer(p[4])
    d <- ee_json_2_df(f, method, region, wy)
    listofdfs[[i]]<-d
  }
  df <- ldply(listofdfs, data.frame) # make into one dataframe 
}

wy_2015 <- load_json(list_of_files)
saveRDS(wy_2015, file="wy_2015.rds")

