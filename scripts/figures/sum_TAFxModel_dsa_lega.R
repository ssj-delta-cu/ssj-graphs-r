sum_TAFxModel_dsa_legal <- function(data, wy){
  
  # summarize total acre-ft just using crops (ie include = "yes")
  af_crops <- data %>% filter(include == "yes") %>%
    dplyr::group_by(model, region, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) %>% filter(wateryear == wy)
  
  # manually chuck results for models that don't conver legal delta
  af_crops_filter <- af_crops %>% filter(model!="eto") %>%
    filter(model!="calsimetaw" & model!="detaw" & model!="sims" | region!="legal")
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  p <- ggplot(af_crops_filter, aes(x=model, y=sum_af, colour=region))+
    geom_point(size=2) +
    ggtitle(paste("Acre-feet totals for crops summed over the", wy ,"water year")) +
    scale_y_continuous(labels = axis_units, limits = c(1000000, 2000000)) +
    ylab("Thousands Acre-Feet") +
    scale_x_discrete(labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
    scale_color_manual(labels = c("Delta Service Area", "Legal Delta"), 
                       values = c('#3366cc', "#dc3912")) +
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
          axis.line.x = element_line(color="black", size = 1),
          axis.line.y = element_line(color="black", size = 1)) # manually add in axis
}