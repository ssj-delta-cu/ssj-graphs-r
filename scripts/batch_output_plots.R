# generate plots
source("scripts/helper_functions.R")
source("scripts/figures.R")

data <- readRDS("data/full_20170509/data_both_wy_20170509.rds")
crops_2_gen <- crop_list()
month_2_gen <- month_list()
methods_2_gen <- methods_names

methods_2_gen <- methods_2_gen[!methods_2_gen %in% c("CalSIMETAW", "DETAW")]

wy <- 2016
aoi <- "dsa"
p <- whisker_ETxMonths_per_crop_method(data, aoi, wy, "UCD-Metric", 2008)
p

# fig6 --------------------------------------------------------------------

# all crops for water year 2015 for the dsa region
folder <- "figs/fig6/"

for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  #plot
  p <- line_ETxMonths(data, cropid, wy, aoi)
  
  # build ouput name
  crop <- gsub(" ", "", crop)
  crop <- gsub("/", "", crop)
  base <- paste(cropid, crop, wy, aoi, sep="-")
  name <- paste(folder, base, ".png", sep="")

  # save
  ggsave(name, p, width=7, height=4, units="in")
  print(name)
}


# fig7 --------------------------------------------------------------------
folder <- "figs/fig7/"

for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  # loop through the months
  for(m in 1:length(month_2_gen)){
    mon <- month_2_gen[m]
    
    #plot
    p <- whisker_ETxModel_per_crop_month(data, aoi, wy, mon, cropid)
    
    # build ouput name
    crop <- gsub(" ", "", crop)
    crop <- gsub("/", "", crop)
    base <- paste(cropid, crop, wy, mon, aoi, sep="-")
    name <- paste(folder, base, ".png", sep="")
    
    # save
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
  }
}


# fig8 --------------------------------------------------------------------
folder <- "figs/fig8/"

for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  # loop through the models
  for(m in 1:length(methods_2_gen)){
    mod <- methods_2_gen[m]
    
    #plot
    p <- whisker_ETxMonths_per_crop_method(data, aoi, wy, mod, cropid)
    
    # build ouput name
    crop <- gsub(" ", "", crop)
    crop <- gsub("/", "", crop)
    m_lower <- lookup_model_name(mod) # get lowercase name
    base <- paste(cropid, crop, wy, m_lower, aoi, sep="-")
    name <- paste(folder, base, ".png", sep="")
    
    # save
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
  }
}

# fig5 --------------------------------------------------------------------
folder <- "figs/fig5/"

wy15sum <- sum_TAFxModel_dsa_legal(data, wy)
ggsave(paste(folder, "TAF_wy2015_dsa_legal", ".png", sep=""), wy15sum, width=7, height=4, units="in")

# pie chart --------------------------------------------------------------------
folder <- "figs/Other/"

# loop through the models
for(m in 1:length(methods_2_gen)){
  mod <- methods_2_gen[m]
  print(mod)
  base <- paste("piechart", wy, mod, sep="-")
  name <- paste(folder, base, ".png", sep="")
  print(name)
  
  #plot
  p <- piechart_TAFxCrop_PERCENT_wy_by_topcrops(data, wy, aoi, mod)
  
  ggsave(name, p, width=7, height=4, units="in")
  
  }


# percent AF + landuse --------------------------------------------------------------------
folder <- "figs/Other/"

landuse <- read.csv("lookups/Crops.csv",  stringsAsFactors=FALSE)
p <- barchart_TAFxModel_PERCENT_wy_by_topcrops(data, wy, aoi, landuse)
name <- paste(folder, "barchart_TAFxModel_percent_wlanduse_2015", ".png", sep="")
ggsave(name, p, width=7, height=4, units="in")


# barcart taf x model  --------------------------------------------------------------------
folder <- "figs/Other/"

p <- barchart_TAFxModel_sum_wy_by_topcrops(data, wy, aoi)
p
name <- paste(folder, "barchart_TAFxModel_2015", ".png", sep="")
ggsave(name, p, width=7, height=4, units="in")



# barcart taf x model facet on months --------------------------------------------------------------------
folder <- "figs/Other/"

p <- barchart_TAFxModel_sum_monthsfacet_by_topcrop(data, wy, aoi)
p
name <- paste(folder, "barchart_TAFxModelxMonth_2015", ".png", sep="")
ggsave(name, p, width=11, height=4, units="in")


# piechart facet
# barcart taf x model facet on months --------------------------------------------------------------------
folder <- "figs/Other/"

p <- piechart_TAFxCropxModel(data, wy, aoi)
p
name <- paste(folder, "pie_facet_wy2015", ".png", sep="")
ggsave(name, p, width=7, height=4, units="in")
