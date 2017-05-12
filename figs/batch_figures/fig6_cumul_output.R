# batch outputs figure 6 showing cummulative ET for both water years on one plot
source('figs/batch_figures/output_settings.R')

#  --------------------------------------------------------------------

# all crops for a water year for a specific region
folder <- "figs/fig6_cumulative/"

# loop through water_years
# loop through the crops
for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  #plot
  p <- line_ETxMonths_cumulative(data, cropid,  aoi)
  
  # build ouput name
  crop <- gsub(" ", "", crop)
  crop <- gsub("/", "", crop)
  base <- paste(cropid, crop, aoi, sep="-")
  name <- paste(folder, base, ".png", sep="")
  
  # save
  ggsave(name, p, width=9, height=4, units="in")
  print(name)
}

