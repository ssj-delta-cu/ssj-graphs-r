# batch outputs all versions of figure 7
source('figs/batch_figures/output_settings.R')

# fig7 --------------------------------------------------------------------
folder <- "figs/fig7/"


data_sub <- data %>% filter(!model %in% c("itrc_co", 'disalexi_co'))
 

# loop through water_years
for(y in 1:length(water_years)){
  wy <- water_years[y]

  # loop through the crops
  for(i in 1:length(crops_2_gen)){
    crop<-crops_2_gen[i]
    cropid <- lookup_cropid(crop)

    # loop through the months
    for(m in 1:length(month_2_gen)){
      month <- month_2_gen[m]

      #plot
      p <- whisker_ETxModel_per_crop_month(data_sub, aoi, wy, month, cropid)

      # build ouput name
      crop <- gsub(" ", "", crop)
      crop <- gsub("/", "", crop)
      base <- paste(cropid, crop, wy, month, aoi, sep="-")
      name <- paste(folder, base, ".png", sep="")

      # save
      ggsave(name, p, width=7, height=4, units="in")
      print(name)
    }
  }
}

