# generate plots
source("scripts/helper_functions.R")
source("scripts/figures.R")

# data to use for generating the plots
dsa_legal_data <- readRDS("data/dsa_legal/dsa_legal_5methods_20170517.rds")

# list of crops to generate
crops_2_gen <- crop_list()

# list of months of the water year (Oct-> sept)
month_2_gen <- month_list()

# lsit of methods to use for the plots
methods_2_gen <- methods_names
methods_2_gen <- methods_2_gen[!methods_2_gen %in% c("CalSIMETAW", "DETAW")]

# region of interest (usually dsa or legal)
aoi <- "dsa"

# water years
water_years <- c(2015, 2016)

# footer 
footer <- paste('Updated ', Sys.Date())
