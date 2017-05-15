# loads geojson file from the island sub-regions into a data frame and save it to a rds
source("scripts/helper_functions.R")

list_of_files <- list.files(path="data/fieldstation_20170515", pattern=".geojson", full.names=TRUE)

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
d <- gather(data, OCT, NOV, DEC, JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, key="month", value="ET_mean") %>% 
  mutate(date = date_from_wy_month(as.numeric(wateryear), month))%>%
  select(Station_ID, Crop, IslandName, model, wateryear, month, date, ET_mean)

d

saveRDS(d, file="data/fieldstation_20170515/fieldstation_20170515.rds")

######################################################################################################

list_of_csvs <- list.files(path="data/fieldstation_20170515", pattern=".csv", full.names=TRUE)

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

m <- load_csv(list_of_csvs)
