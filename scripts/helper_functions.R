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
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)
  wateryr <- mutate(months, cmb=paste(months$WaterYear, months$Month))
  days <- wateryr$NumberDays[match(paste(wy, month), wateryr$cmb)]
  return(days)
}

# lookup month year from water year for a nicer title
lookup_month_year <- function(wy, month){
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
                  "ucdmetric"="#56b4df", "ucd_metric"="#56b4df", "ucdpt"="#f0e442", "ucd_pt"="#f0e442")