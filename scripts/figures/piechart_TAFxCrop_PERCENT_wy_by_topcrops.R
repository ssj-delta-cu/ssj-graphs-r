piechart_TAFxCrop_PERCENT_wy_by_topcrops <- function(data, wy, aoi, select_model){
  top_crops <- c("Alfalfa", "Almonds", "Corn", "Fallow", "Pasture", "Potatoes", "Rice",  "Tomatoes", "Vineyards")
  
  af_crops_top_only <- data %>% 
    filter_no_eto() %>% 
    filter(wateryear == wy) %>% 
    filter(region == aoi) %>% 
    filter(include == "yes") %>% 
    filter(cropname %in% top_crops) %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  af_crops_others <- data %>% 
    filter_no_eto() %>% 
    filter(wateryear == wy) %>% 
    filter(region == aoi) %>% 
    filter(include == "yes") %>% 
    filter(!cropname %in% top_crops) %>% 
    mutate(cropname = "Other") %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  #  merge af_crops_top_only and af_crops_others
  af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)
  
  # filter by methods
  af_crops_w_other_single <- af_crops_w_others %>% filter(model == select_model)
  af_crops_w_other_single <- af_crops_w_other_single %>% mutate(percent = round(sum_af/sum(sum_af)*100))

  af_crops_w_other_single$cropname <-factor(af_crops_w_other_single$cropname)
  af_crops_w_other_single <- af_crops_w_other_single %>% 
    arrange(desc(cropname)) %>% mutate(pos = cumsum(percent)-percent/2)

  # labels
  lab_sum <- paste(af_crops_w_other_single$percent,"%")
  total_af <- sum(af_crops_w_other_single$sum_af)
  taf <- round(total_af/1000)
  lab_af <- paste(taf, "TAF")
  
  p<-ggplot(af_crops_w_other_single, aes(x="", y=percent, fill=cropname))+
    geom_bar(width = 1, stat="identity")+ 
    ggtitle(toupper(select_model))+
    coord_polar("y") +
    theme_bw() + 
    geom_text(aes(x=1.25, y = pos, label=lab_sum), size=3)+
    geom_text(aes(x=1.6, y = 0, label=lab_af), size=4)+
    scale_fill_manual(values=crop_palette)+
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.border = element_blank(),
      panel.grid = element_blank(),
      plot.title = element_text(hjust = 0.5),
      axis.ticks = element_blank(),
      axis.text.x = element_blank(), # plot labels
      legend.position="bottom", # position of legend or none
      legend.direction="horizontal", # orientation of legend
      legend.title= element_blank(), # no title for legend
      legend.key.size = unit(0.5, "cm") # size of legend
    ) 
  p
}



