library(sf)
library(geosphere)
library(dplyr)
source("scripts/helper_functions.R")

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
acre_feet_per_month <- function(df, wy, month){
  #num_days_in_month
  numdays <- num_days_in_month(wy, month)
  
  # name of the field with the month's mean
  mean_field <- paste(month, '_', 'mean', sep='')
  
  # name of the field with the month's count
  count_field <- paste(month, '_', 'count', sep='')
  
  # output name for the field with the month's acre-feet total
  output_fieldname <- paste(month, '_', 'ACREFT', sep='')
  
  # add field that calculates acre-feet for month using mean, count, number of days in month and reducer
  d <- df %>% mutate_(xyz = interp(~acre_feet(m, c, numdays, 200), m=as.name(mean_field), c=as.name(count_field)))
  names(d)[names(d) == "xyz"] <- output_fieldname
  return(d)
} 

# read in geojson export and add fields parsed from filename and calculate monthly and wy acre-feet
add_fields <- function(geojson){
  model_year <- get_filename_info(geojson)
  d <- st_read(geojson) # read geojson file to dataframe
  d$model <- model_year[1] # add name of model parsed from filename
  d$wateryear <- model_year[2] # add water year parsed from filename
  d$source <- geojson # add the filepath as the source
  
  # calculate island/region area from geojson (units in square meters)
  d$AREA_m <- st_area(d)
  
  #add fields for each month's acre-feet
  for(m in month.abb){
    d<-acre_feet_per_month(d, model_year[2], toupper(m))
  }

  # calculate water year total acre-feet by adding all the monthly acre-feet columns
  d$WY_ACREFT <- d$OCT_ACREFT + d$NOV_ACREFT + d$DEC_ACREFT + d$JAN_ACREFT + 
    d$FEB_ACREFT + d$MAR_ACREFT + d$APR_ACREFT + d$MAY_ACREFT + d$JUN_ACREFT + 
    d$JUL_ACREFT + d$AUG_ACREFT + d$SEP_ACREFT
  return(d)
}
