# batch outputs all versions of figure 8
source('figs/batch_figures/output_settings.R')

# fig8 --------------------------------------------------------------------
folder <- "figs/fig8/"

# loop through water_years
for(y in 1:length(water_years)){
  wy <- water_years[y]
# loop through all crops types
for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  # loop through the models
  for(m in 1:length(methods_2_gen)){
    mod <- methods_2_gen[m]
    
    # plot
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
}


