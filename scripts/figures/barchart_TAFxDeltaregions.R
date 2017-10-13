barchart_TAFxDeltaregions <- function(data, water_year){
  
  af <- data %>%
    filter(!model=='eto')%>%
    filter(include == "yes", wateryear==water_year, crop_acft > 0) %>%
    dplyr::group_by(model, region) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) 
  
  

  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  
  
  # sims doesn't include wet herbaceous or semi ag so we'll add a point 
  # that represents the average of all methods for herbaceous/sub irrigated pasture.
  
  # To calculate the estimate, take the total acre-feet for the sims and subtract the values for the herb and semi-ag classes. Then,
  # calculate the mean value from the other models for these two classes and add it to the total.
  
  # total acre-feet for sims for the two classes (to subtract from the total since the EE output has a non-zero value)
  sims_herb_semi <- data %>% filter(model=="sims", wateryear==water_year, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(region) %>% 
    dplyr::summarise(sum_wetherb_semiag=sum(crop_acft))
  
  # Calculate the average for herb + semi-ag for the other models for the two regions
  mean_herb_semi <- data %>% filter(!model=="sims", !model=="eto") %>%
    filter(wateryear==water_year, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(model, region) %>%
    dplyr::summarise(sum_af=sum(crop_acft)) %>%
    dplyr::group_by(region) %>%
    dplyr::summarise(mean_2classes=mean(sum_af))
  
  # get sims TAF results for DSA
  sims <- af %>% filter(model=="sims")
  
  # join the sims sum for herb_semi and the mean value for herb_semi for the two regions
  sims_joined <- dplyr::left_join(dplyr::left_join(sims, sims_herb_semi, by="region"), mean_herb_semi, by="region")
  
  # subtract the herb_sumi total from the orignal value and add the mean for the two crops
  sims_joined_est <- sims_joined %>% mutate(sum_af_est=(sum_af - sum_wetherb_semiag + mean_2classes))
  
  # clean up columns by droping intermediate columns and renaming estimate to sum_af
  sims_est <- sims_joined_est %>% dplyr::select(c(model, region, sum_af_est)) %>% rename(sum_af=sum_af_est)
  
  # remove sims from af_crop_filter and add in the new estimated results
  af_wo_sims <- af %>% filter(!model=="sims")
  bind <- bind_rows(af_wo_sims,  sims_est)
  
  
  
  
  
  
  p <- ggplot(bind, aes(x=region, y=sum_af, fill=model))+geom_bar(stat = "identity", position='dodge') +
    theme_bw() +
    #ggtitle(paste("Water Year ", water_year))+
    scale_fill_manual(values=model_palette, labels=methods_named_list)+
    scale_y_continuous(labels = axis_units) + #, limits = c(0, 300000)) +
    ylab("Thousand Acre-Feet") +
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
          axis.line.y = element_line(color="black", size = 1))  # manually add in axis
  p}




