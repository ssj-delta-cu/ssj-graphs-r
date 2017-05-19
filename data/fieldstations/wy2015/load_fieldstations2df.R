# loads geojson file from the island sub-regions into a data frame and save it to a rds
source("scripts/helper_functions.R")

list_of_files <- list.files(path="data/fieldstations/wy2015", pattern=".geojson", full.names=TRUE)

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
  select(Station, model, wateryear, month, date, ET_mean) %>% 
  filter(between(as.Date(date), as.Date('2015-09-01'), as.Date('2015-10-01'))) %>%  # filter dates where there is field station data overlap
  mutate(ET_mean = ET_mean/10)


######################################################################################################

# load the csv with the bare field measures
bare_field_measure <- read.csv("data/fieldstations/wy2015/DailyET_Delta2015_FallowFieldEst.csv", stringsAsFactors = F)

bare_gather <- bare_field_measure %>% gather(station, daily_et, 2:7)

avg_by_station <- bare_gather %>% group_by(station) %>% 
  na.omit %>% 
  summarise(field_mean_et=mean(daily_et, na.rm=T)) %>%
  separate(station, c("Station", "measure_type"), sep="ETa_")


######################################################################################################

# bind the field data with the remote sensing data
d <- inner_join(rs, avg_by_station, by=c("Station"))
d

saveRDS(d, 'data/fieldstations/wy2015/fieldstations_wy2015_20170519.rds')
