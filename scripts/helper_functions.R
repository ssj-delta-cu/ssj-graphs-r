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



####################################################################
#### Lookups
####################################################################

crops <- c('Alfalfa'=1, 
           'Safflower'=12, 
           'Sunflower'=22, 
           'Corn'=23, 
           'Rice'=24, 
           'Bush Berries'=108, 
           'Vineyards'=109, 
           'Potatoes'=246, 
           'Cucurbit'=277, 
           'Tomatoes'=278, 
           'Truck Crops'=279, 
           'Cherries'=403, 
           'Olives'=409, 
           'Pears'=412, 
           'Citrus'=425, 
           'Almonds'=500, 
           'Pistachios'=502, 
           'Walnuts'=503, 
           'Pasture'=800, 
           'Fallow'=916, 
           'Semi-agricultural/ROW'=913, 
           'Other Deciduous'=914, 
           'Turf'=908, 
           'Floating Vegetation'=2002, 
           'Forage Grass'=2003, 
           'Riparian'=2004, 
           'Upland Herbaceous'=2005, 
           'Urban'=2006, 
           'Water'=2007, 
           'Wet herbaceous/sub irrigated pasture'=2008, 
           'Unknown'=0, 
           'Asparagus'=201, 
           'Carrots'=211, 
           'Young Orchard'=752, 
           'Sudan Grass'=14, 
           'Nursery'=756, 
           'Eucalyptus'=284
           )

lookup_cropname <- function(id){
  # load the crop id from the crop named list
  cropname = names(which(crops == id))
  return(cropname)
}

lookup_cropid <- function(cropname){
  # load the crop id name table
  cropid = crops[[cropname]]
  return(cropid)
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

# lookup full month name for a nicer title
lookup_month_fullname <- function(month){
  month <- toupper(month)
  # load the months table
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)
  
  full =  months$Full[match(month, months$Month)]
  return(full)
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
                       "sims"="SIMS", "ucdmetric"="UCD-METRIC", "ucdpt"="UCD-PT", "eto"="ETo", "landuse"="Landuse")

# get the actual date from the water year and the month
date_from_wy_month <- function(water_year, month){
  year <- ifelse(month %in% c("OCT", "NOV", "DEC"), yes=(water_year-1), no=(water_year))
  first <- paste(year, month, 1) # fake date for first of the month
  d <- as.Date(strptime(first, format='%Y %b %d'))
  return(d)}


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









