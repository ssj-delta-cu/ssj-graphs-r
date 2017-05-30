sum_TAFxModel_dsa_legal <- function(data, wy){
  
  # summarize total acre-ft just using crops (ie include = "yes")
  af <- data %>% filter(include == "yes", wateryear==wy, crop_acft > 0) %>%
    dplyr::group_by(model, region) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) 
  
  # manually remove results for models that don't conver legal delta
  af_cover <- af %>% 
    filter(model!="eto") %>% # removes spatial cimis ETo 
    filter(model!="calsimetaw" & model!="detaw" | region!="legal") # these models don't cover legal delta
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  # sims doesn't include wet herbaceous or semi ag so we'll add a point 
  # that represents the average of all methods for herbaceous/sub irrigated pasture.
  
  # To calculate the estimate, take the total acre-feet for the sims and subtract the values for the herb and semi-ag classes. Then,
  # calculate the mean value from the other models for these two classes and add it to the total.
  
  # total acre-feet for sims for the two classes (to subtract from the total since the EE output has a non-zero value)
  sims_herb_semi <- data %>% filter(model=="sims", wateryear==wy, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(region) %>% 
    dplyr::summarise(sum_wetherb_semiag=sum(crop_acft))
  
  # Calculate the average for herb + semi-ag for the other models for the two regions
  mean_herb_semi <- data %>% filter(!model=="sims", !model=="eto") %>%
    filter(wateryear==wy, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(model, region) %>%
    dplyr::summarise(sum_af=sum(crop_acft)) %>%
    dplyr::group_by(region) %>%
    dplyr::summarise(mean_2classes=mean(sum_af))
  
  # get sims TAF results for DSA
  sims <- af_cover %>% filter(model=="sims")
  
  # join the sims sum for herb_semi and the mean value for herb_semi for the two regions
  sims_joined <- dplyr::left_join(dplyr::left_join(sims, sims_herb_semi, by="region"), mean_herb_semi, by="region")
  
  # subtract the herb_sumi total from the orignal value and add the mean for the two crops
  sims_joined_est <- sims_joined %>% mutate(sum_af_est=(sum_af - sum_wetherb_semiag + mean_2classes))
  
  # clean up columns by droping intermediate columns and renaming estimate to sum_af
  sims_est <- sims_joined_est %>% select(c(model, region, sum_af_est)) %>% rename(sum_af=sum_af_est)
  
  # remove sims from af_crop_filter and add in the new estimated results
  af_cover_wo_sims <- af_cover %>% filter(!model=="sims")
  bind <- bind_rows(af_cover_wo_sims,  sims_est)
  
  # calculate the mean value for all the groups for the dsa regions and the legal delta
  region_averages <- bind %>% 
    dplyr::group_by(region) %>%
    dplyr::summarise(avg=mean(sum_af), median=median(sum_af))
  
  # values for the horizontal lines
  dsa_intercept <- region_averages$avg[region_averages$region=='dsa']
  legal_intercept <- region_averages$avg[region_averages$region=='legal']
  
  # values for the sims astrix for estimated values
  dsa_astx <- bind$sum_af[bind$region=='dsa'&bind$model=='sims']
  legal_astx <- bind$sum_af[bind$region=='legal'&bind$model=='sims']
  
  p <- ggplot(bind, aes(x=model, y=sum_af, colour=region))+
    geom_point(size=3.5) +
    ggtitle(paste("Acre-feet totals for crops summed over the", wy ,"water year")) +
    scale_y_continuous(labels = axis_units, limits = c(1000000, 2000000)) +
    ylab("Thousands Acre-Feet") +
    scale_x_discrete(limit=c("calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucdmetric", "ucdpt"), labels=methods_named_list)+ 
    scale_color_manual(labels = c("Delta Service Area", "Legal Delta"), 
                       values = c('#3366cc', "#dc3912")) +
    geom_hline(aes(yintercept=dsa_intercept), colour="#3366cc", linetype="dashed", size=1.25, alpha=0.5)+
    geom_hline(aes(yintercept=legal_intercept), colour="#dc3912", linetype="dashed", size=1.25, alpha=0.5)+
    theme_bw() +  
    theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="bottom", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"), # size of legend
          axis.line = element_line(color="black", size = 1),
          axis.text=element_text(size=12),
          axis.title=element_text(size=14, face="bold")) # manually add in axis
  
  # add in the astrix for the sims data points
  p2 <- p + annotate("text", x = 'sims', y = dsa_astx, label = c("   *"), size=8) + 
    annotate("text", x = 'sims', y = legal_astx, label = c("   *"), size=8)
}
