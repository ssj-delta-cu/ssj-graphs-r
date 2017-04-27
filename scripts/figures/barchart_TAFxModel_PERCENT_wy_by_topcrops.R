barchart_TAFxModel_PERCENT_wy_by_topcrops<- function(data, wy, aoi, landuse){
  
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
  
  
  # landuse (this includes all types including water, native, etc)
  landuse_top <- landuse %>% 
    filter(Include == "yes") %>% 
    filter(Commodity %in% top_crops) %>% 
    select(Commodity, LandIQ_2015_Acres)
  
  landuse_others <- landuse %>% 
    filter(!Commodity %in% top_crops)%>%
    filter(Include == "yes") %>% 
    mutate(Commodity = "Other") %>%
    dplyr::group_by(Commodity) %>% 
    dplyr::summarize(LandIQ_2015_Acres = sum(LandIQ_2015_Acres))
  
  landuse_both <- dplyr::union(landuse_top, landuse_others)
  names(landuse_both) <- c("cropname","sum_af")
  landuse_both["model"]<-"landuse"
  
  # union landuse with the model data
  af_crops_landuse <- dplyr::union(af_crops_w_others, landuse_both)
  
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x*100
  }
  
  af_crop_percent <- af_crops_landuse %>%  
    dplyr::group_by(model)%>% 
    dplyr::mutate(model_percent=sum_af/sum(sum_af))
  
  af_crop_percent$model <- factor(af_crop_percent$model, levels=c("landuse", "calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucdmetric", "ucdpt"))
  
  p <- ggplot(af_crop_percent, aes(x=model, y=model_percent, fill=cropname))+geom_bar(stat="identity") +  
    scale_x_discrete(labels=c("Landuse", "CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
    theme_bw() + 
    scale_fill_manual(values=crop_palette)+
    scale_y_continuous(labels = axis_units, limits = c(0, 1)) +
    ylab("% Total") +
    theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="bottom", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"), # size of legend
          axis.line.x = element_line(color="black", size = 1),
          axis.line.y = element_line(color="black", size = 1)) # manually add in axis
  p
  
}