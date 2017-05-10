whisker_ETxMonths_per_crop_method <- function(data, aoi_region, wy, model_name, cropid){
  model <- lookup_model_name(model_name) # returns model name as lowercase and without the dash
  
  # get only data for a given region, water year, month, crop for a single model
  data_subset <- filter_cropid_wy_region(data, cropid, wy, aoi_region) %>% 
    filter_model(model) # selects only one model
  
  # alters the y-axis units for labels
  axis_units <-function(x){
    x/10
  }
  
  # change order of months to match water year
  data_subset$month <- factor(data_subset$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  # make a boxplot showing each month's range of values
  p <- ggplot(data_subset, aes(x=month, ymin=p9, lower=p25, middle=median, upper=p75,  ymax=p91))+
    geom_boxplot(stat="identity", colour='#193366', fill='#3366cc', lwd=1, fatten=0.5) +
    ggtitle(paste(model_name, "\n", lookup_cropname(cropid), "\n", "Water Year:", wy)) + # plot title
    scale_y_continuous(labels = axis_units)+
    coord_cartesian(ylim=c(0,120))+ # changes the plot visual zoom instead of rm data (http://stackoverflow.com/questions/11617267/how-to-get-geom-boxplot-to-apply-y-limits-before-calculating-boxes)
    ylab("ET (mm/day)") +
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