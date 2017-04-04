# fig 7 comparison of daily average et for a month

# Figure 7 in interim report
source("scripts/helper_functions.R")

crop_whisker_plot_for_one_month <- function(data, aoi_region, wy, month, cropid){

  # get only data for a giver region, water year, month, crop
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
  p
}



###########################################################################################
# example
data <- readRDS("wy_2015.rds") # load data (rds created in json2df.R)
p <- crop_whisker_plot_for_one_month(data, "dsa", 2015, "JUL", 1)
p
###########################################################################################


# export figures
# save_fig7 <- function(x, month, wy) {
#   # loop through all the crops and save as png
#   folder = 'figs/fig7/'
#   
#   Number <- x[1]
#   Number <- gsub(" ", "", Number)
#   crop <- x[2]
#   crop <- gsub(" ", "", crop)
#   crop <- gsub("/", "", crop)
#   
#   month_wy <- lookup_month_year(wy, month)
#   month_wy <- gsub(" ", "", month_wy)
#   
#   if(x[3]=="yes"){
#     base <- paste(Number, crop, month_wy, sep="-")
#     name <- paste(folder, base, ".png", sep="")
#     # make plot
#     p <- crop_whisker_plot_for_one_month(data, wy, month, as.integer(Number)) # note AOI region hardcoded here
#     ggsave(name, p, width=7, height=4, units="in")
#     print(name)
#   }
#   else{
#     print("skip")
#   }
#   
# }
#
#apply(crops, 1, save_fig7, month="JUL", wy=2015)
