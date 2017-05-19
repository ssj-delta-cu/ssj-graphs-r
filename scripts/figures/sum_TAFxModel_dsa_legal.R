sum_TAFxModel_dsa_legal <- function(data, wy){
  
  # summarize total acre-ft just using crops (ie include = "yes")
  af_crops <- data %>% filter(include == "yes") %>%
    dplyr::group_by(model, region, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) %>% filter(wateryear == wy)
  
  # manually chuck results for models that don't conver legal delta
  af_crops_filter <- af_crops %>% 
    filter(model!="eto") %>% # removes spatial cimis ETo 
    filter(model!="calsimetaw" & model!="detaw" & model!="sims" | region!="legal") # these models don't cover legal delta
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  # sims doesn't include wet herbaceous or semi ag so we'll add a point that represents the average of all methods for herbaceous/sub irrigated pasture.
  
  # total acre-feet for sims for these two classes (to subtract from the total)
  sims_est_wetherb_semi_ag <- data %>% filter(model=="sims", region=='dsa', wateryear==wy, level_2 %in% c(2008, 913)) %>%
    dplyr::summarise(sum_wetherb_semiag=sum(crop_acft))
  
  # get the average for the rest of the models for the two classes
  mean_est_wetherb_semi_ag <- data %>% filter(!model=="sims", !model=="eto") %>%
    filter(region=='dsa', wateryear==wy, level_2 %in% c(2008, 913)) %>%
    dplyr::group_by(model) %>%
    dplyr::summarise(sum_af=sum(crop_acft)) %>%
    dplyr::summarise(mean_2classes=mean(sum_af))
  
  # get sims TAF results for DSA
  sims <- af_crops_filter %>% filter(model=="sims")
  
  # remove wet herb semi ag from sims total (this will be their original estimate)
  sims_or <- sims
  sims_or$sum_af <- sims$sum_af - sims_est_wetherb_semi_ag$sum_wetherb_semiag
  sims_or_taf <- sims_or$sum_af[1]
  
  # add the mean value for the two classes to their original estimate
  sims_enh <- sims
  sims_enh$sum_af <- sims$sum_af - sims_est_wetherb_semi_ag$sum_wetherb_semiag + mean_est_wetherb_semi_ag$mean_2classes
  sims_enh_taf <- sims_enh$sum_af[1]
  
  # remove sims from af_crop_filter and add in the new estimated results
  af_crop_filter_wo_sims <- af_crops_filter %>% filter(!model=="sims")
  bind <- bind_rows(af_crop_filter_wo_sims,  sims_enh)
  
  # calculate the mean value for all the groups for the dsa regions and the legal delta
  region_averages <- bind %>% 
    dplyr::group_by(region) %>%
    dplyr::summarise(avg=mean(sum_af), median=median(sum_af))
  
  dsa_intercept <- region_averages$avg[region_averages$region=='dsa']
  legal_intercept <- region_averages$avg[region_averages$region=='legal']
  
  # now add in the "sims" orginal
  bind2 <- bind_rows(bind, sims_or)
  
  p <- ggplot(bind2, aes(x=model, y=sum_af, colour=region))+
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
  
  # add in the extra data point for sims
  p2 <- p + annotate("text", x = 'sims', y = sims_enh$sum_af, label = c("   *"), size=8) + 
    annotate("text", x = 'sims', y = sims_or$sum_af, label = c("   '"), size=8)
  p3 <- p2 + labs(caption=paste("SIMS: ", round(sims_or_taf/1000), "TAF", "\n", "SIMS + AVG: ", round(sims_enh_taf/1000), "TAF"))
  p3
}
