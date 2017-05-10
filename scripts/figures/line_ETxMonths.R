line_ETxMonths<- function(data, crop_id, water_year, aoi_region){
  # creates a line plot for ET by months of a single water year for a specifc crop and region
  
  # subset data by selected crop id number, water year, region
  sub<-filter_cropid_wy_region(data, crop_id, water_year, aoi_region) %>% filter_no_eto
  
  # look up the cropname 
  cropname <- lookup_cropname(crop_id)
  
  # change order of months to follow water year Oct -> Sept
  sub$month <- factor(sub$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  # construct the plot object
  p <- ggplot(sub, aes(month, mean/10, color=model, group=model)) + 
    geom_line(size=1)+
    coord_cartesian(ylim=c(0, 10))+
    ggtitle(paste(cropname, "\n", "Water Year", water_year)) +
    ylab("ET (mm/day)") +
    scale_color_manual(values=model_palette) +
    theme_bw() +  # change theme simple with no axis or tick marks
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="none", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm") # size of legend
    )+
    theme(axis.line.x = element_line(color="black", size = 1),
          axis.line.y = element_line(color="black", size = 1)) # manually add in axis
}