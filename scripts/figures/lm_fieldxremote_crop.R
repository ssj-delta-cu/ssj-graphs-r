lm_fieldxremote_crop <- function(data, single_crop){
  
  # filter out any NAs
  t <- data %>% filter(!is.na(ET_SR_aH_qc_Dgf )) %>%
    filter(Crop == single_crop)
  
  # capitalize the facets
  capitalize <- function(string) {
    substr(string, 1, 1) <- toupper(substr(string, 1, 1))
    string
  }
  
  # GET EQUATION AND R-SQUARED AS STRING
  # SOURCE: http://goo.gl/K4yh
  
  lm_eqn <- function(df){
    m <- lm(ET_mean ~ ET_SR_aH_qc_Dgf, df);
    eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                     list(a = format(coef(m)[1], digits = 2), 
                          b = format(coef(m)[2], digits = 2), 
                          r2 = format(summary(m)$r.squared, digits = 3)))
    as.character(as.expression(eq));                 
  }
  

  
  
  
  
  p <- ggplot(t, aes(x=ET_SR_aH_qc_Dgf, y=ET_mean, color=model, group=model))+
    geom_point(size=1.5)+
    ylab("Model ET (mm/day)")+
    xlab("Field ET (mm/day)")+
    geom_smooth(method=lm,se=FALSE, fullrange=FALSE, size=1.25) + # Add linear regression line
    scale_color_manual(values=model_palette, labels=methods_named_list)+
    coord_cartesian(xlim = c(0,10), ylim = c(0,10))+
    #coord_equal(ratio=1)+
    geom_abline(intercept = 0, slope = 1, colour="black", linetype="dashed", size=1.25, alpha=0.5)+ #1:1 diagonal line
    #annotate(geom = "text", x = 0.5, y = 1, label = "1:1", colour="black", alpha=0.5, angle = 45)+
    ggtitle(capitalize(single_crop))+
    geom_text(x =8, y = 2.5, label = lm_eqn(t), parse = TRUE)+
    theme_bw()+
    theme(panel.border = element_rect(colour = "black", fill="NA", size=1),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          legend.position="none", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"),
          axis.text.y = element_text(size=12),
          axis.text.x = element_text(size=12),
          axis.title = element_text(size=14))+ 
    guides(colour = guide_legend(nrow = 1, keywidth = 3, keyheight = 1),
           fill = guide_legend(keywidth = 1, keyheight = 1),
           linetype=guide_legend(keywidth = 3, keyheight = 1))
  p
}