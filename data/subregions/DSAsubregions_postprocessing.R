

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
  numdays <- num_days_in_month_csv(wy, month)
  
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

num_days_in_month_csv <- function(wy, month){
  # load the months
  month <- toupper(month)
  months <- read.csv('lookups/months.csv', stringsAsFactors=FALSE)
  wateryr <- mutate(months, cmb=paste(months$WaterYear, months$Month))
  days <- wateryr$NumberDays[match(paste(wy, month), wateryr$cmb)]
  return(days)
}

####################################################################################
####################################################################################

list_of_files <- list.files(path="data/subregions", pattern=".geojson", full.names=TRUE)
listofdfs <- list() #Create a list in which you intend to save your df's.

# for loop to load in all the raw json files to single data frame
for (i in 1:length(list_of_files)) {
  print(list_of_files[i])
  g <- subregions_add_fields(list_of_files[i], 30)
  listofdfs[[i]]<-g
}
df_subregions <- ldply(listofdfs, data.frame) # make into one dataframe 

saveRDS(df_subregions, file="data/subregions/subregions.rds")
write.csv(df_subregions, file="data/subregions/subregions.csv", row.names = FALSE)


