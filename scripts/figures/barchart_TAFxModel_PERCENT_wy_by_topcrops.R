barchart_TAFxModel_PERCENT_wy_by_topcrops<- function(data, wy, aoi){
  
  top_crops <- c("Alfalfa", "Corn", "Fallow", "Pasture", "Tomatoes", "Vineyards")
  
  af_crops_top_only <- data %>% 
    filter(!model=="eto") %>%
    filter(wateryear == wy, region == aoi, include == "yes", cropname %in% top_crops, crop_acft>0) %>% 
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  af_crops_others <- data %>% 
    filter(!model=="eto") %>% 
    filter(wateryear == wy, region == aoi, include == "yes", crop_acft>0) %>% 
    filter(!cropname %in% top_crops) %>% 
    mutate(cropname = "Other") %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  #  merge af_crops_top_only and af_crops_others
  af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)
  
  
  landuse <- read.csv("lookups/Crops.csv",  stringsAsFactors=FALSE)
  
  if(wy == 2015){
    
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
  }else if(wy==2016){
    # landuse (this includes all types including water, native, etc)
    landuse_top <- landuse %>% 
      filter(Include == "yes") %>% 
      filter(Commodity %in% top_crops) %>% 
      select(Commodity, LandIQ_2016_Acres)  
    
    landuse_others <- landuse %>% 
      filter(!Commodity %in% top_crops)%>%
      filter(Include == "yes") %>% 
      mutate(Commodity = "Other") %>%
      dplyr::group_by(Commodity) %>% 
      dplyr::summarize(LandIQ_2016_Acres = sum(LandIQ_2016_Acres))
  }
  
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
    dplyr::mutate(model_percent=sum_af/sum(sum_af))%>%
    dplyr::mutate(rank=dense_rank(sum_af))
  
  
  # ggplot stacks bars based on the order of the apperence in the dataframe
  af_crop_percent <- arrange(af_crop_percent, model, model_percent)
  
  
  # create two groups to seperate landuse as seperate facet
  af_crop_percent$facet_var <- ifelse(af_crop_percent$model == "landuse", c('Landuse'), c('zET'))
  
  af_crop_percent$model <- factor(af_crop_percent$model, levels=c("landuse", "calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucdmetric", "ucdpt"))
  
  
  p <- ggplot(af_crop_percent, aes(x=model, y=model_percent, fill=reorder(cropname, rank)))+ # reorder uses the percentage to change stack order
    geom_bar(stat="identity") +  
    scale_x_discrete(labels=methods_named_list)+ 
    theme_bw() + 
    facet_grid(~ model, scales= 'free', space= 'free')+
    scale_fill_manual(values=crop_palette)+
    scale_y_continuous(labels = axis_units, limits = c(0, 1)) +
    ylab("% Total") +
    theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="right", # position of legend or none
          legend.direction="vertical", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.75, "cm"), # size of legend
          axis.text.y=element_text(size=14),
          axis.text.x=element_text(size=12),
          axis.title.y=element_text(size=14),
          axis.line.x = element_line(color="black", size = 1), # manually add in axis
          axis.line.y = element_line(color="black", size = 1), # manually add in axis
          strip.text.x = element_blank()) 
    #theme(strip.background = element_blank(), strip.placement = "outside", strip.text.x = element_blank())
  p <- p + geom_text(aes(label=paste(round(model_percent*100, 1), '%')), size = 4, position = position_stack(vjust = 0.5))
  p
}