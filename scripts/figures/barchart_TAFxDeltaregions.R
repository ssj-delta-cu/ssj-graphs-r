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
  
  p <- ggplot(af, aes(x=region, y=sum_af, fill=model))+geom_bar(stat = "identity", position='dodge') +
    theme_bw() +
    ggtitle(paste("Water Year ", water_year))+
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




