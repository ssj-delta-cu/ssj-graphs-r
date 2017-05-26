whisker_ETxMonths_per_crop_method_2yrs <- function(data, aoi_region, model_name, cropid){
  selected_model <- lookup_model_name(model_name) # returns model name as lowercase and without the dash
  
  # get only data for a given region, water year, month, crop
  data_subset <- data %>% filter(region == aoi_region, level_2 == cropid, model==selected_model) %>% 
    filter_no_eto %>% # removes ETO from models
    mutate(date=date_from_wy_month(wateryear, month)) # add a date field by combining month and water year
    
  # alters the y-axis units for labels
  axis_units <-function(x){
    x/10
  }
  
  # change order of months to match water year
  #data_subset$month <- factor(data_subset$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  # make a boxplot showing each month's range of values
  p <- ggplot(data_subset, aes(x=date, ymin=p9, lower=p25, middle=median, upper=p75,  ymax=p91, fill=model))+
    geom_boxplot(stat="identity") +
    scale_fill_manual(values=model_palette, labels=methods_named_list)+
    ggtitle(paste(model_name, "\n", lookup_cropname(cropid), sep='')) + # plot title
    scale_y_continuous(labels = axis_units)+
    scale_x_date(date_breaks="3 month", date_labels  = "%b")+
    coord_cartesian(ylim=c(0,100))+ # changes the plot visual zoom instead of rm data (http://stackoverflow.com/questions/11617267/how-to-get-geom-boxplot-to-apply-y-limits-before-calculating-boxes)
    ylab("ET (mm/day)") +
    theme_bw() +  
    theme(panel.border = element_blank(),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          legend.position="none", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"), # size of legend
          axis.line.x = element_line(color="black", size = 1),
          axis.text.y=element_text(size=14),
          axis.text.x=element_text(size=12),
          axis.line.y = element_line(color="black", size = 1)) # manually add in axis
}

# p <- whisker_ETxMonths_per_crop_method_2yrs(dsa_legal_data, 'dsa', 'SIMS', 913)
# 
# p
# ggsave("box_2yrs_continuous.png", p, width=7, height=4, units="in")

