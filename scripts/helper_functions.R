# common helper functions


####################################################################
#### Packages
####################################################################


if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}

if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
}

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}

if(!require(tidyr)){
  install.packages("tidyr")
  library(tidyr)
}

if(!require(jsonlite)){
  install.packages("jsonlite")
  library(jsonlite)
}

if(!require(sf)){
  install.packages("sf")
  library(sf)
}

if(!require(geosphere)){
  install.packages("geosphere")
  library(geosphere)
}

if(!require(lazyeval)){
  install.packages("lazyeval")
  library(lazyeval)
}

####################################################################
#### Lookups
####################################################################

lookup_cropname <- function(id){
  # load the crop id name table
  crops <- read.csv('lookups/crops.csv', stringsAsFactors=FALSE)
  cropname = crops$Commodity[match(id, crops$Number)]
  return(cropname)
}

lookup_cropid <- function(cropname){
  # load the crop id name table
  crops <- read.csv('lookups/crops.csv', stringsAsFactors=FALSE)
  cropid = crops$Number[match(cropname, crops$Commodity)]
  return(cropid)
}

lookup_include <- function(id){
  # load the crop id name table
  crops <- read.csv('lookups/crops.csv', stringsAsFactors=FALSE)
  include = crops$Include[match(id, crops$Number)]
  return(include)
}

num_days_in_month <- function(wy, month){
  # load the months
  month <- toupper(month)
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)
  wateryr <- mutate(months, cmb=paste(months$WaterYear, months$Month))
  days <- wateryr$NumberDays[match(paste(wy, month), wateryr$cmb)]
  return(days)
}

# lookup month year from water year for a nicer title
lookup_month_year <- function(wy, month){
  month <- toupper(month)
  # load the months table
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)

  sub_wy <- months %>% filter(WaterYear == wy)
  full =  sub_wy$Full[match(month, sub_wy$Month)]

  fullname_year <- paste(full, wy)

  return(fullname_year)
}

# looks up model name by casing to lower and striping out dashes
lookup_model_name <- function(name){
  lower <- tolower(name)
  db_name <- gsub("-", "", lower)
}

# list of all crop names
crop_list <-  function(){
  # load the crop id name table
  crops <- read.csv('lookups/crops.csv', stringsAsFactors=FALSE)
  lu_crops_only <- crops %>% filter(Include == "yes")
  crops_list <- unique(lu_crops_only$Commodity)
}

month_list <- function(){
  # load the crop id name table
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)
  mlist <- unique(months$Month)
}

methods_list <- function(){
  methods<-c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT")
  m <- tolower(methods)
  m2 <- gsub("-", "", m)
}

methods_names<-c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT")

methods_named_list <-c("calsimetaw"="CalSIMETAW", "detaw"="DETAW", "disalexi"="DisALEXI", "itrc"="ITRC",
                       "sims"="SIMS", "ucdmetric"="UCD-METRIC", "ucdpt"="UCD-PT")

# get the actual date from the water year and the month
date_from_wy_month <- function(water_year, month){
  year <- ifelse(month %in% c("OCT", "NOV", "DEC"), yes=(water_year-1), no=(water_year))
  first <- paste(year, month, 1) # fake date for first of the month
  d <- as.Date(strptime(first, format='%Y %b %d'))
  return(d)}


# calculate acre-feet from monthly avg daily ET
acre_feet <- function(mean_et, cell_count, number_days, reducer_size){
  # Crop_acre_feet = (count) * (reducer pixel size) ^2 * (sq m to acres) * (mean daily ET) /10* (mm to feet) * (num days in month)
  mm2ft <- 0.00328084
  sqm2acres <- 0.000247105
  crop_acft <- cell_count * reducer_size^2 * sqm2acres * mean_et / 10 * mm2ft * number_days 
  return(crop_acft)
}

####################################################################
#### Filters
####################################################################

# filter out eto model results
filter_no_eto <- function(data){
  df <- filter(data, model!="eto")
}

# return data for a given crop, water year, and region
filter_cropid_wy_region <- function(data, crop_id, water_year, aoi_region){
  df <- filter(data, region == aoi_region, level_2 == crop_id, wateryear == water_year)
}

# return data for a given crop and region
filter_cropid_region <- function(data, crop_id, aoi_region){
	df <- filter(data, region == aoi_region, level_2 == crop_id)
}

# return data for a specific month
filter_month <- function(data, selected_month){
  df <- data %>% filter(month == selected_month)
}

# return data for a specific model
filter_model <- function(data, selected_model){
  df <- data %>% filter(model == selected_model)
}

####################################################################
#### Color Standards
####################################################################
crop_palette <- c(Alfalfa = "#0ab54e", Almonds = "#feaca7", Corn = "#fffb58",
                  Fallow = "#fe9a2f", Other="#b3dda5", Pasture ="#ffc98b",
                  Potatoes="#c7b8dc", Rice="#99cbee", Tomatoes="#e44746", Vineyards="#7b5baa")

model_palette = c("calsimetaw"="#0072b2", "detaw"="#d55e00", "disalexi"="#e69f00",
                  "itrc"="#009e73", "sims"="#cc79a7",
                  "ucdmetric"="#56b4df", "ucd_metric"="#56b4df", "ucdpt"="#f0e442", "ucd_pt"="#f0e442", 'eto'='#000000')

model_lny = c("calsimetaw"=1, "detaw"=1, "disalexi"=1,
                  "itrc"=1, "sims"=1,"ucdmetric"=1,
                  "ucd_metric"=1, "ucdpt"=1, "ucd_pt"=1, 'eto'=2)


####################################################################
#### Data Loading
####################################################################

####################################################################
# data loading functions for processsing full delta area

ee_geojson_properties_2_df <-function(json, model, aoi, wy, reducer_size){
  # where json = path to json with results, model = model group name, aoi = region of the results, wy=water year
  lists_dfs_by_month <- jsonlite::fromJSON(json)$features$properties
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
  df <- mutate(df, crop_acft=acre_feet(mean, count, num_days, reducer_size))
  return(df)
}

####################################################################
# data loading functions for processsing EE geojson for subregions
# note this data does not include any crop information
# All non-ag area should be masked out in EE

# parse model and year from filename. Should be similiar to disalexi-DSAsubregions-2015.geojson
get_filename_info <- function(file){
  # get the basename from the file path
  b <- basename(file)
  
  # split filename into parts
  b_ex <- strsplit(b, "\\.") 
  n <- b_ex[[1]][1] # name without extension
  
  n_split <- strsplit(n, "-")
  m <- n_split[[1]][1]
  yr <- n_split[[1]][3]
  return(c(m, yr))
}

# calculate acre-feet per month
acre_feet_per_month <- function(df, wy, month, reducer_size){
  #num_days_in_month
  numdays <- num_days_in_month(wy, month)
  
  # name of the field with the month's mean
  mean_field <- paste(month, '_', 'mean', sep='')
  
  # name of the field with the month's count
  count_field <- paste(month, '_', 'count', sep='')
  
  # output name for the field with the month's acre-feet total
  output_fieldname <- paste(month, '_', 'ACREFT', sep='')
  
  # add field that calculates acre-feet for month using mean, count, number of days in month and reducer
  d <- df %>% mutate_(xyz = interp(~acre_feet(m, c, numdays, reducer_size), m=as.name(mean_field), c=as.name(count_field)))
  names(d)[names(d) == "xyz"] <- output_fieldname
  return(d)
} 

# read in geojson export and add fields parsed from filename and calculate monthly and wy acre-feet
subregions_add_fields <- function(geojson, reducer_size){
  model_year <- get_filename_info(geojson)
  d <- st_read(geojson) # read geojson file to dataframe
  d$model <- model_year[1] # add name of model parsed from filename
  d$wateryear <- model_year[2] # add water year parsed from filename
  d$source <- geojson # add the filepath as the source
  
  # calculate island/region area from geojson (units in square meters)
  d$AREA_m <- st_area(d)
  
  #add fields for each month's acre-feet
  for(m in month.abb){
    d<-acre_feet_per_month(d, model_year[2], toupper(m), reducer_size)
  }
  
  # calculate water year total acre-feet by adding all the monthly acre-feet columns
  d$WY_ACREFT <- d$OCT_ACREFT + d$NOV_ACREFT + d$DEC_ACREFT + d$JAN_ACREFT + 
    d$FEB_ACREFT + d$MAR_ACREFT + d$APR_ACREFT + d$MAY_ACREFT + d$JUN_ACREFT + 
    d$JUL_ACREFT + d$AUG_ACREFT + d$SEP_ACREFT
  return(d)
}

####################################################################
# data loading functions for processsing EE geojson for fieldpoints
fieldpts_tidyup <- function(geojson){
  model_year <- get_filename_info(geojson)
  d <- st_read(geojson) # read geojson file to dataframe
  d$model <- model_year[1] # add name of model parsed from filename
  d$wateryear <- model_year[2] # add water year parsed from filename
  return(d)
}


