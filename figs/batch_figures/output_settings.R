# generate plots
source("scripts/helper_functions.R")
source("scripts/figures.R")

# dataframe to use for generating the plots
data <- readRDS("data/full_20170509/data_both_wy_20170509.rds")
data <- data %>% filter(!model == 'itrc_co') # remove the CO results from ITRC

# list of crops to generate
crops_2_gen <- crop_list()

# list of months of the water year (Oct-> sept)
month_2_gen <- month_list()

# lsit of methods to use for the plots
methods_2_gen <- methods_names
methods_2_gen <- methods_2_gen[!methods_2_gen %in% c("CalSIMETAW", "DETAW")]

# region of interest (usually dsa or legal)
aoi <- "dsa"

water_years <- c(2015, 2016)

# footer 
footer <- paste('Updated ', Sys.Date())
