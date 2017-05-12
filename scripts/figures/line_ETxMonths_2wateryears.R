line_ETxMonths_2wateryears<- function(data, crop_id, aoi_region){
  # creates a line plot for ET by months of a single water year for a specifc crop and region
  
  # subset data by selected crop id number, region
  sub_data <- filter(data, region == aoi_region, level_2 == crop_id) %>% 
    mutate(date=date_from_wy_month(wateryear, month)) # add a date field by combining month and water year

  # look up the cropname 
  cropname <- lookup_cropname(crop_id)

    # change order of months to follow water year Oct -> Sept
  #sub_data$month <- factor(sub_data$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  # construct the plot object
  p <- ggplot(sub_data, aes(date, mean/10, color=model, group=model)) + 
    geom_line(aes(linetype=model),size=1.25)+
    scale_x_date(date_breaks="1 month", date_labels  = "%b")+
    coord_cartesian(ylim=c(0, 9))+
    ggtitle(cropname) +
    ylab("ET (mm/day)") +
    scale_color_manual(values=model_palette) +
    scale_linetype_manual(values=model_lny)+
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

# data2 <- data %>% filter(!model == 'itrc_co')
# p <- line_ETxMonths_2wateryears(data2, 1, 'dsa')
# p
# ggsave("Alf_w_ETo.png", p, width=7, height=4, units="in")





