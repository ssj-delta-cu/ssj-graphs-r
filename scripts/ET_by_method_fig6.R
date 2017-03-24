# compare ET by method

# Figure 6 in interim report

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



# filter data by water year & crop type for a given region
data_wy_crop <- function(crop_id, water_year, aoi_region){
  df <- filter(data, region == aoi_region, level_2 == crop_id, wateryear == water_year, model!="eto")
}

plot_crop_et_by_month <- function(crop_id, water_year, aoi_region){
  sub<-data_wy_crop(crop_id, water_year, aoi_region)
  
  cropname <- lookup_cropname(crop_id)
  
  # change order of months to follow wateryr
  sub$month <- factor(sub$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  p <- ggplot(sub, aes(month, mean/10, color=model, group=model)) + 
    geom_line(size=1)+
    ylim(0,9)+
    ggtitle(cropname) +
    ylab("ET (mm/day)") +
    theme_bw() +  # change theme simple with no axis or tick marks
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          #axis.title.y=element_blank(),
          #axis.text.y=element_blank(),
          #axis.ticks.y=element_blank(),
          #axis.ticks.x=element_blank(),
          axis.title.x = element_blank(),
          legend.position="none", # position of legend
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(1.5, "cm") # size of legend
    )+
    theme(axis.line.x = element_line(color="black", size = 1),
          axis.line.y = element_line(color="black", size = 1)) # manually add in axis
  
  p
}


###########################################

alf <- plot_crop_et_by_month(1, 2015, "dsa")
alm <- plot_crop_et_by_month(500, 2015, "dsa")
corn <- plot_crop_et_by_month(23, 2015, "dsa")
past <- plot_crop_et_by_month(800, 2015, "dsa")
potat <- plot_crop_et_by_month(246, 2015, "dsa")
rice <- plot_crop_et_by_month(24, 2015, "dsa")
toma <- plot_crop_et_by_month(278, 2015, "dsa")
vine <- plot_crop_et_by_month(109, 2015, "dsa")

alf 
alm 
corn 
past
potat
rice  # note rice has some values about the ylim when set at (0,8) #TODO
toma 
vine

