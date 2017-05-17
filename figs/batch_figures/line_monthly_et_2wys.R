# batch outputs monthly et + ref Eto for both water years on one plot
source('figs/batch_figures/output_settings.R')

fig_num <- 11

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)


# loop through water_years
# loop through the crops
for(i in 1:length(crops_2_gen)){
  crop<-crops_2_gen[i]
  cropid <- lookup_cropid(crop)
  
  #plot
  p <- line_ETxMonths_2wateryears(dsa_legal_data, cropid,  aoi)
  
  # add footer
  p <- p + labs(caption=footer)
  
  # build ouput name
  crop <- gsub(" ", "", crop)
  crop <- gsub("/", "", crop)
  base <- paste(cropid, crop, aoi, sep="-")
  base.ext <- paste(base, ".png", sep="")
  name <- paste(file.path(mainDir, subDir), base.ext, sep="/")
  
  # save
  ggsave(name, p, width=7, height=4, units="in")
  print(name)
}


