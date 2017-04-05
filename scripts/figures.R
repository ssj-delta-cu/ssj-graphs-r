# code to create figures
source("scripts/helper_functions.R")


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
    coord_cartesian(ylim=c(0, 8))+
    ggtitle(cropname) +
    ylab("ET (mm/day)") +
    scale_color_manual(labels = c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"), 
                       values = c('#3366cc', "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477")) +
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


whisker_ETxModel_per_crop_month <- function(data, aoi_region, wy, month, cropid){
  # creates a whisker plot for ET for all models using a single crop and month (fig 7.)
  
  # get only data for a given region, water year, month, crop
  data_subset <- filter_cropid_wy_region(data, cropid, wy, aoi_region) %>% 
    filter_no_eto %>% # removes ETO from models
    filter_month(month) # selects only one month
  
  axis_units <-function(x){
    x/10
  }
  
  plot_title <-paste(lookup_cropname(cropid), "in", lookup_month_year(wy, month))
  
  # make a plot
  p <- ggplot(data_subset, aes(x=model, ymin=p9, lower=p25, middle=median, upper=p75,  ymax=p91))+
    geom_boxplot(stat="identity", colour='#193366', fill='#3366cc', lwd=1, fatten=0.5) +
    ggtitle(plot_title) +
    scale_y_continuous(labels = axis_units, limits = c(0, 100)) +
    ylab("ET (mm/day)") +
    scale_x_discrete(labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
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

# fig 8
whisker_ETxMonths_per_crop_method <- function(data, aoi_region, wy, model, cropid){
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
