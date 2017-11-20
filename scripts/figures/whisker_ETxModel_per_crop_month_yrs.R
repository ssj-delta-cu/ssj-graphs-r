whisker_ETxModel_per_crop_month_2yrs <- function(data, aoi_region, selected_month, cropid){
  # creates a whisker plot for ET for all models using a single crop and month (fig 7.)
  
  # get only data for a given region, water year, month, crop
  data_subset <- data %>% filter(region == aoi_region, level_2 == cropid, month == selected_month) %>% 
    filter_no_eto  # removes ETO from models

  
  axis_units <-function(x){
    x/10
  }
  
 
  
  plot_title <-paste(lookup_cropname(cropid), "in", lookup_month_fullname(selected_month))
  
  # boxplot fill colors
  num_unique_models <- length(unique(data_subset$model)) # get number of unique groups
  cols <- c('#0072b2', '#d55e00') # colors for the two years
  fill_colors_list <- rep(cols, num_unique_models) # create vector repeating color by the number of models
  
  # make a plot
  p <- ggplot(data_subset, aes(x=model, ymin=p9, lower=p25, middle=median, upper=p75,  ymax=p91, width=0.75, group = wateryear))+
    geom_boxplot(aes( fill=wateryear),  stat="identity", lwd=1, fatten=0.75, position=position_dodge(width=0.85), fill=fill_colors_list) + #colour='#193366', fill='#3366cc',
    ggtitle(plot_title) +
    scale_y_continuous(labels = axis_units)+ #  limits = c(0, 100)) +
    coord_cartesian(ylim=c(0,100))+ # changes the plot visual zoom instead of rm data (http://stackoverflow.com/questions/11617267/how-to-get-geom-boxplot-to-apply-y-limits-before-calculating-boxes)
    ylab("ET (mm/day)") +
    scale_x_discrete(labels=methods_named_list)+ #labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT")
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
          axis.line.y = element_line(color="black", size = 1),
          axis.text.y=element_text(size=14),
          axis.title.y=element_text(size=14),
          axis.text.x=element_text(size=12)) # manually add in axis
}

# p <- whisker_ETxModel_per_crop_month_2yrs(dsa_legal_data, 'dsa', 'JUL', 1)
# p

