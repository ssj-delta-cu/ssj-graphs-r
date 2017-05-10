# batch outputs all versions of figure 6
source('figs/batch_figures/output_settings.R')

#  --------------------------------------------------------------------

# all crops for a water year for a specific region
folder <- "figs/fig6/"

# loop through water_years
for(y in 1:length(water_years)){
  wy <- water_years[y]
  # loop through the crops
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
}
