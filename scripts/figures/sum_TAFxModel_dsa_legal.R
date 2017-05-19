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
  
  # calculate the mean value for all the groups for the dsa regions and the legal delta
  region_averages <- af_crops_filter %>% 
    dplyr::group_by(region) %>%
    dplyr::summarise(avg=mean(sum_af), median=median(sum_af))
  
  dsa_intercept <- region_averages$avg[region_averages$region=='dsa']
  legal_intercept <- region_averages$avg[region_averages$region=='legal']
  
  
  p <- ggplot(af_crops_filter, aes(x=model, y=sum_af, colour=region))+
    geom_point(size=3.5) +
    ggtitle(paste("Acre-feet totals for crops summed over the", wy ,"water year")) +
    scale_y_continuous(labels = axis_units, limits = c(800000, 1500000)) +
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
  
}