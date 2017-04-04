# common helper functions


####################################################################
#### Packages 
####################################################################


if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
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

if(!require(plyr)){
  install.packages("plyr")
  library(plyr)
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

lookup_include <- function(id){
  # load the crop id name table
  crops <- read.csv('lookups/crops.csv', stringsAsFactors=FALSE)
  include = crops$Include[match(id, crops$Number)]
  return(include)
}

num_days_in_month <- function(wy, month){
  # load the months
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)
  wateryr <- mutate(months, cmb=paste(months$WaterYear, months$Month))
  days <- wateryr$NumberDays[match(paste(wy, month), wateryr$cmb)]
  return(days)
}

# lookup month year from water year for a nicer title
lookup_month_year <- function(wy, month){
  # load the months table
  months <- read.csv('data/months.csv', stringsAsFactors=FALSE)
  
  sub_wy <- months %>% filter(WaterYear == wy)
  full =  sub_wy$Full[match(month, sub_wy$Month)]
  
  fullname_year <- paste(full, wy)
  
  return(fullname_year)
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

# return data for a specific month
filter_month <- function(data, selected_month){
  df <- data %>% filter(month == selected_month)
}
