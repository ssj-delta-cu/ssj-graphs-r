# fig 8 whisker plot for model, crop, wy

# Figure 8 in interim report
source("scripts/helper_functions.R")

crop_whisker_plot_for_model <- function(data, aoi_region, wy, model, cropid){
  
  # get only data for a giver region, water year, month, crop
  data_subset <- filter_cropid_wy_region(data, cropid, wy, aoi_region) %>% 
    filter_no_eto %>% # removes ETO from models
    filter_model(model) # selects only one model
  
  axis_units <-function(x){
    x/10
  }
  
  # change order of months to match water year
  data_subset$month <- factor(data_subset$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  plot_title <-paste(toupper(model), "-", lookup_cropname(cropid))
  
  # make a plot
  p <- ggplot(data_subset, aes(x=month, ymin=p9, lower=p25, middle=median, upper=p75,  ymax=p91))+
    geom_boxplot(stat="identity", colour='#193366', fill='#3366cc', lwd=1, fatten=0.5) +
    ggtitle(plot_title) +
    scale_y_continuous(labels = axis_units, limits = c(0, 100)) +
    ylab("ET (mm/day)") +
    #scale_x_discrete(labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
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
  p
}



###########################################################################################
# example
# data <- readRDS("wy_2015.rds") # load data (rds created in json2df.R)
# p <- crop_whisker_plot_for_model(data, "dsa", 2015, "calsimetaw", 23)
# p
###########################################################################################

