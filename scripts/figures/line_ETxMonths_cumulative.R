line_ETxMonths_cumulative<- function(data, crop_id, aoi_region){
  # creates a cumulative line plot for ET and facet by water year for a specifc crop and region

  # subset data by selected crop id number, water year, region
  sub<-filter_cropid_region(data, crop_id, aoi_region) %>% 
    filter_no_eto %>%
    mutate(date=date_from_wy_month(wateryear, month)) # add a date field by combining month and water year


  # look up the cropname
  cropname <- lookup_cropname(crop_id)

  # change order of months to follow water year Oct -> Sept
  sub$month <- factor(sub$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))

  # calculate the monthly cumulative et
  cumulative_et <- sub %>% 	group_by(wateryear, model) %>%
  													arrange(month) %>%
  													mutate(monthly_et=(mean/10)*num_days) %>%
  													mutate(cum_et=cumsum(monthly_et))
  
  # construct the plot object
  p <- ggplot(cumulative_et, aes(date, cum_et, color=model, group=model)) +
    geom_line(size=1.25)+
    coord_cartesian(ylim=c(0, 1200))+
    ggtitle(cropname) +
    ylab("Cumulative ET (mm)") +
    scale_color_manual(values=model_palette) +
    scale_x_date(date_breaks="3 month", date_labels  = "%b")+
    theme_bw() +  # change theme simple with no axis or tick marks
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="none", # position of legend or none
          axis.text.y=element_text(size=14),
          axis.text.x=element_text(size=12),
          axis.title.y=element_text(size=14)
    )+
    facet_wrap(~wateryear, scales = "free_x") +
    theme(strip.background = element_blank(), 
          strip.placement = "outside", 
          strip.text.x = element_text(size = 14),
          axis.line.x = element_line(color="black", size = 1),
          axis.line.y = element_line(color="black", size = 1))
  

  p
}

