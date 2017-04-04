# fig 7 comparison of daily average et for a month

# Figure 7 in interim report

if(!require(ggplot2)){
  install.packages("ggplot2")
  library(ggplot2)
}

if(!require(dplyr)){
  install.packages("dplyr")
  library(dplyr)
}


# load data (rds created in json2df.R)
data <- readRDS("wy_2015.rds")

# load the crop id name table
crops <- read.csv('data/crops.csv', stringsAsFactors=FALSE)


# lookup crop name from csv
lookup_cropname <- function(id){
  cropname = crops$Commodity[match(id, crops$Number)]
  return(cropname)
}

# lookup month year from water year for a nicer title
lookup_month_year <- function(wy, month){
  # load the months table
  months <- read.csv('data/months.csv', stringsAsFactors=FALSE)
  
  sub_wy <- months %>% filter(WaterYear == wy)
  full =  sub_wy$Full[match(month, sub_wy$Month)]
  
  fullname_year <- paste(full, wy)
  
  return(fullname_year)
}


filter_region_wy_month_cropid <- function(df, selected_region, selected_wy, selected_month, selected_crop){
  df2 <- df %>% 
    filter(model != "eto")%>%
    filter(region == selected_region) %>% 
    filter(wateryear == selected_wy) %>% 
    filter(month == selected_month) %>% 
    filter(level_2 == selected_crop)
  df2
}

crop_whisker_plot_for_one_month <- function(data, wy, month, cropid){

  # get only data for a giver region, water year, month, crop
  data_subset <- filter_region_wy_month_cropid(data, "dsa", wy, month, cropid)
  
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

# export figures
save_fig7 <- function(x, month, wy) {
  # loop through all the crops and save as png
  folder = 'figs/fig7/'
  
  Number <- x[1]
  Number <- gsub(" ", "", Number)
  crop <- x[2]
  crop <- gsub(" ", "", crop)
  crop <- gsub("/", "", crop)
  
  month_wy <- lookup_month_year(wy, month)
  month_wy <- gsub(" ", "", month_wy)
  
  if(x[3]=="yes"){
    base <- paste(Number, crop, month_wy, sep="-")
    name <- paste(folder, base, ".png", sep="")
    # make plot
    p <- crop_whisker_plot_for_one_month(data, wy, month, as.integer(Number)) # note AOI region hardcoded here
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
  }
  else{
    print("skip")
  }
  
}


apply(crops, 1, save_fig7, month="JUL", wy=2015)
