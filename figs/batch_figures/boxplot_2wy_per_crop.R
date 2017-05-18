# batch outputs all boxplots
source('figs/batch_figures/output_settings.R')

fig_num <- 13

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)



# loop through the crops
for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)

  # loop through the months
  for(m in 1:length(month_2_gen)){
    month <- month_2_gen[m]

    #plot
    p <- whisker_ETxModel_per_crop_month_2yrs(dsa_legal_data, aoi, month, cropid)
    
    # add footer
    p <- p + labs(caption=footer)

    # build ouput name
    crop <- gsub(" ", "", crop)
    crop <- gsub("/", "", crop)
    base <- paste(cropid, crop, month, aoi, sep="-")
    base.ext <- paste(base, ".png", sep="")
    name <- paste(file.path(mainDir, subDir), base.ext, sep="/")
    
    # save
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
    
  }
}

