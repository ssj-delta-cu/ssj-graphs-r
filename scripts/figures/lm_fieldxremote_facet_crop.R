# linear regression plot comparing the field station measurements with remote sensing estimates

lm_fieldxremote_facet_crop <- function(data){

  # filter out any NAs
  t <- data %>% filter(!is.na(ET_SR_aH_qc_Dgf ))
  
  # capitalize the facets
  capitalize <- function(string) {
    substr(string, 1, 1) <- toupper(substr(string, 1, 1))
    string
  }
  
  # rename maize to corn
  t$Crop <- gsub('maize', 'corn', t$Crop)
  
  
  p <- ggplot(t, aes(x=ET_SR_aH_qc_Dgf, y=ET_mean, color=model))+
    geom_point(size=1.5)+
    ylab("Model ET (mm/day)")+
    xlab("Field ET (mm/day)")+
    geom_smooth(method=lm,se=FALSE, fullrange=FALSE, size=1.25) + # Add linear regression line
    scale_color_manual(values=model_palette, labels=methods_named_list)+
    #coord_cartesian(xlim = c(0,8), ylim = c(0,8))+
    geom_abline(intercept = 0, slope = 1, colour="black", linetype="dashed", size=1.25, alpha=0.5)+ #1:1 diagonal line
    #annotate(geom = "text", x = 0.5, y = 1, label = "1:1", colour="black", alpha=0.5, angle = 45)+
    theme_bw()+
    theme(panel.border = element_rect(colour = "black", fill="NA", size=1),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          legend.position="bottom", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"),
          axis.text.y = element_text(size=12),
          axis.text.x = element_text(size=12),
          axis.title = element_text(size=14))+ 
    facet_wrap(~Crop, nrow=3, ncol=1, labeller = labeller(Crop = capitalize), scale="free")+
    theme(strip.background = element_blank(),
          strip.placement = "outside", 
          strip.text.x = element_text(size = 16))+
    guides(colour = guide_legend(nrow = 2, keywidth = 3, keyheight = 1),
           fill = guide_legend(keywidth = 1, keyheight = 1),
          linetype=guide_legend(keywidth = 3, keyheight = 1))
  p
}

