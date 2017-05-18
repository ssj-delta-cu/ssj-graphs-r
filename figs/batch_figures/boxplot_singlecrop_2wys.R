# batch outputs all versions 
source('figs/batch_figures/output_settings.R')

fig_num <- 14

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)


# loop through water_years
# loop through all crops types
for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  # loop through the models
  for(m in 1:length(methods_2_gen)){
    mod <- methods_2_gen[m]
    
    # plot
    p <- whisker_ETxMonths_per_crop_method_2yrs(dsa_legal_data, aoi, mod, cropid)
    
    # add footer
    p <- p + labs(caption=footer)
    
    # build ouput name
    crop <- gsub(" ", "", crop)
    crop <- gsub("/", "", crop)
    m_lower <- lookup_model_name(mod) # get lowercase name
    base <- paste(cropid, crop, m_lower, aoi, sep="-")
    base.ext <- paste(base, ".png", sep="")
    name <- paste(file.path(mainDir, subDir), base.ext, sep="/")
    
    # save
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
  }
}



