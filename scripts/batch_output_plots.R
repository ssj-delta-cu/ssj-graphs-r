# generate plots
source("scripts/helper_functions.R")
source("scripts/figures.R")

data <- readRDS("wy_2015.rds")
crops_2_gen <- crop_list()
month_2_gen <- month_list()
methods_2_gen <- methods_list()
wy <- 2015
aoi <- "dsa"

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
    base <- paste(cropid, crop, wy, mon, region, sep="-")
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
    base <- paste(cropid, crop, wy, mod, region, sep="-")
    name <- paste(folder, base, ".png", sep="")
    
    # save
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
  }
}

