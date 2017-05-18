line_ETxMonths_2wateryears<- function(data, crop_id, aoi_region){
  # creates a line plot for ET by months for a specifc crop and region
  
  # subset data by selected crop id number, region
  sub_data <- filter(data, region == aoi_region, level_2 == crop_id) %>% 
    mutate(date=date_from_wy_month(wateryear, month)) # add a date field by combining month and water year

  # look up the cropname 
  cropname <- lookup_cropname(crop_id)

  # construct the plot object
  p <- ggplot(sub_data, aes(date, mean/10, color=model, group=model)) + 
    geom_line(aes(linetype=model),size=1.25)+
    scale_x_date(date_breaks="3 month", date_labels  = "%b")+
    coord_cartesian(ylim=c(0, 9))+
    ggtitle(cropname) +
    ylab("ET (mm/day)") +
    geom_vline(xintercept = as.numeric(as.Date('2015-10-01')),colour="black", linetype="dashed", size=1.25, alpha=0.5)+
    annotate("text", x=as.Date('2015-04-01') , y=9, label="2015", size=5)+
    annotate("text", x=as.Date('2016-04-01') , y=9, label="2016", size=5)+
    scale_color_manual(values=model_palette) +
    scale_linetype_manual(values=model_lny)+
    theme_bw() +  # change theme simple with no axis or tick marks
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5, size=16),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="none", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"),
          axis.text.y=element_text(size=14),
          axis.text.x=element_text(size=12),
          axis.title.y=element_text(size=14),
          axis.line = element_line(color="black", size=1)
          )
}