# loads geojson file from the island sub-regions into a data frame and save it to a rds
source("scripts/helper_functions.R")

list_of_files <- list.files(path="data/fieldstations/wy2016", pattern=".geojson", full.names=TRUE)

# for loop to load in all the raw json files to single data frame
load_json <- function(file_list) {
  
  listofdfs <- list() #Create a list in which you intend to save your df's.
  
  for (i in 1:length(file_list)) {
    print(file_list[i])
    g <- fieldpts_tidyup(file_list[i])
    listofdfs[[i]]<-g
  }
  df <- ldply(listofdfs, data.frame) # make into one dataframe 
}

data <- load_json(list_of_files)


# gather cases and select columns to keep
rs <- gather(data, OCT, NOV, DEC, JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, key="month", value="ET_mean") %>% 
  mutate(date = date_from_wy_month(as.numeric(wateryear), month))%>%
  select(Station_ID, Crop, IslandName, model, wateryear, month, date, ET_mean) %>% 
  filter(between(as.Date(date), as.Date('2016-05-01'), as.Date('2016-10-01'))) %>%  # filter dates where there is field station data overlap
  mutate(ET_mean = ET_mean/10)


######################################################################################################

# pull in the daily csv from the ssj-field-measurements-2016 repo (assumes that there is a local copy)
# the local copy should have the same directory folder as ssj-graphs-r
list_of_csvs <- list.files(path="../ssj-field-measurements-2016/daily data", pattern="D[0-9][0-9](.*?)(.csv)", full.names=TRUE)

# for loop to load in all the raw csv files to single data frame
load_csv <- function(file_list) {
  
  listofdfs <- list() #Create a list in which you intend to save your df's.
  
  for (i in 1:length(file_list)) {
    print(file_list[i])
    g <- read.csv(file_list[i], stringsAsFactors = FALSE)
    listofdfs[[i]]<-g
  }
  df <- ldply(listofdfs, data.frame) # make into one dataframe 
}

raw_field_data <- load_csv(list_of_csvs)

# clean up station name and set model to field
field <- raw_field_data %>% separate(stationName, into = c("Station_ID", "IslandName", "Crop"), sep='_') %>%
  filter(between(as.Date(date), as.Date('2016-05-01'), as.Date('2016-09-30'))) %>%   # filter out dates that are past sep 2016 
  group_by(Station_ID, month=toupper(format(as.Date(date), '%b'))) %>%
  summarise(ET_SR_aH_qc_Dgf=mean(ET_SR_aH_qc_Dgf, na.rm=TRUE), ET_EC_qc_Dgf = mean(ET_EC_qc_Dgf, na.rm=TRUE)) # calculate the monthly average

######################################################################################################

# bind the field data with the remote sensing data
d <- inner_join(rs, field, by=c("Station_ID", "month"))
d

saveRDS(d, 'data/fieldstations/wy2016/fieldstations_wy2016_20170519.rds')
