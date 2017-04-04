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

if(!require(gridExtra)){
  install.packages("gridExtra")
  library(gridExtra)
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

# single plot for fig 6
plot_crop_et_by_month <- function(crop_id, water_year, aoi_region){
  sub<-data_wy_crop(crop_id, water_year, aoi_region)
  
  cropname <- lookup_cropname(crop_id)
  
  # change order of months to follow wateryr
  sub$month <- factor(sub$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  p <- ggplot(sub, aes(month, mean/10, color=model, group=model)) + 
    geom_line(size=1)+
    #ylim(0,9)+
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
  
  p
}


###########################################


# example of creating a single crop (alfala)
alf <- plot_crop_et_by_month(1, 2015, "dsa")

###########################################

# grid_arrange_2x4 <- function(...) {
#   plots <- list(...)
#   a <- grid.arrange(grobs=plots, ncol = 2, nrow=4)
#   
#   # get legend from first plot
#   g <- ggplotGrob(plots[[1]] + theme(legend.position="bottom"))$grobs
#   
# }
# 
# grid <- grid_arrange_2x4(alf, alm, corn,past, potat, rice, toma, vine)


# hack to get the legend
p <- plot_crop_et_by_month(1, 2015, "dsa")
g <- ggplotGrob(p + theme(legend.position="bottom"))$grobs
legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
plot(legend)

###########################################


# loop through all the crops and save as png
folder = 'figs/fig6/'

save_fig6 <- function(x, wy) {
  Number <- x[1]
  Number <- gsub(" ", "", Number)
  crop <- x[2]
  crop <- gsub(" ", "", crop)
  crop <- gsub("/", "", crop)
  if(x[3]=="yes"){
    base <- paste(Number, crop, wy, sep="-")
    name <- paste(folder, base, ".png", sep="")
    # make plot
    p <- plot_crop_et_by_month(Number, wy, "dsa") # note AOI region hardcoded here
    ggsave(name, p, width=7, height=4, units="in")
    print(name)
  }
  else{
    print("skip")
  }
  
}

apply(crops, 1, save_fig6, wy=2015)

