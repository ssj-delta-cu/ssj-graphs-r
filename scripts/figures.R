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


# Plot that summarizes the af_crops by the two regions
sum_TAFxModel_dsa_legal <- function(data, wy){
  
  # summarize total acre-ft just using crops (ie include = "yes")
  af_crops <- data %>% filter(include == "yes") %>%
    dplyr::group_by(model, region, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) %>% filter(wateryear == wy)
  
  # manually chuck results for models that don't conver legal delta
  af_crops_filter <- af_crops %>% filter(model!="eto") %>%
    filter(model!="calsimetaw" & model!="detaw" & model!="sims" | region!="legal")
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  p <- ggplot(af_crops_filter, aes(x=model, y=sum_af, colour=region))+
    geom_point(size=2) +
    ggtitle(paste("Acre-feet totals for crops summed over the", wy ,"water year")) +
    scale_y_continuous(labels = axis_units, limits = c(1000000, 2000000)) +
    ylab("Thousands Acre-Feet") +
    scale_x_discrete(labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
    scale_color_manual(labels = c("Delta Service Area", "Legal Delta"), 
                       values = c('#3366cc', "#dc3912")) +
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


barchart_TAFxModel_sum_wy_by_topcrops <- function(data, wy, aoi){
  
  top_crops <- c( "Rice", "Wet herbaceous/sub irrigated pasture", "Tomatoes", "Vineyards", "Semi-agricultural/ROW", "Fallow", "Pasture","Corn", "Alfalfa")


af_crops_top_only <- data %>% 
  filter_no_eto() %>% 
  filter(wateryear == wy) %>% 
  filter(region == aoi) %>% 
  filter(include == "yes") %>% 
  filter(cropname %in% top_crops) %>%
  dplyr::group_by(model, cropname) %>% 
  dplyr::summarise(sum_af=sum(crop_acft))

af_crops_others <- data %>% 
  filter_no_eto() %>% 
  filter(wateryear == wy) %>% 
  filter(region == aoi) %>% 
  filter(include == "yes") %>% 
  filter(!cropname %in% top_crops) %>% 
  mutate(cropname = "Other") %>%
  dplyr::group_by(model, cropname) %>% 
  dplyr::summarise(sum_af=sum(crop_acft))

#  merge af_crops_top_only and af_crops_others
af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)

# modify axis units (acre-ft -> thousands acre-feet)
axis_units <-function(x){
  x/1000
}

p <- ggplot(af_crops_w_others, aes(x=model, y=sum_af, fill=cropname))+geom_bar(stat = "identity") +  
  scale_x_discrete(labels=c("CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
  theme_bw() + 
  scale_fill_brewer(palette="Set3")+
  scale_y_continuous(labels = axis_units, limits = c(0, 2000000)) +
  ylab("Thousands Acre-Feet") +
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
p}


barchart_TAFxModel_PERCENT_wy_by_topcrops <- function(data, wy, aoi, landuse){
  data <- wy_2015
  wy <- 2015
  aoi <- "dsa"
  landuse <- read.csv("lookups/Crops.csv",  stringsAsFactors=FALSE)
  
  top_crops <- c( "Rice", "Wet herbaceous/sub irrigated pasture", "Tomatoes", "Vineyards", "Semi-agricultural/ROW", "Fallow", "Pasture","Corn", "Alfalfa")
  
  af_crops_top_only <- data %>% 
    filter_no_eto() %>% 
    filter(wateryear == wy) %>% 
    filter(region == aoi) %>% 
    filter(include == "yes") %>% 
    filter(cropname %in% top_crops) %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  af_crops_others <- data %>% 
    filter_no_eto() %>% 
    filter(wateryear == wy) %>% 
    filter(region == aoi) %>% 
    filter(include == "yes") %>% 
    filter(!cropname %in% top_crops) %>% 
    mutate(cropname = "Other") %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  #  merge af_crops_top_only and af_crops_others
  af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)
  
  
  # landuse (this includes all types including water, native, etc)
  landuse_top <- landuse %>% 
    filter(Include == "yes") %>% 
    filter(Commodity %in% top_crops) %>% 
    select(Commodity, LandIQ_2015_Acres)
  
  landuse_others <- landuse %>% 
    filter(!Commodity %in% top_crops)%>%
    filter(Include == "yes") %>% 
    mutate(Commodity = "Other") %>%
    dplyr::group_by(Commodity) %>% 
    dplyr::summarize(LandIQ_2015_Acres = sum(LandIQ_2015_Acres))
  
  landuse_both <- dplyr::union(landuse_top, landuse_others)
  names(landuse_both) <- c("cropname","sum_af")
  landuse_both["model"]<-"landuse"
  
  # union landuse with the model data
  af_crops_landuse <- dplyr::union(af_crops_w_others, landuse_both)
  
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x*100
  }
  
  af_crop_percent <- af_crops_landuse %>%  
    dplyr::group_by(model)%>% 
    dplyr::mutate(model_percent=sum_af/sum(sum_af))
  
  af_crop_percent$model <- factor(af_crop_percent$model, levels=c("landuse", "calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucd_metric", "ucd-pt"))
  
  p <- ggplot(af_crop_percent, aes(x=model, y=model_percent, fill=cropname))+geom_bar(stat="identity") +  
    scale_x_discrete(labels=c("Landuse", "CalSIMETAW", "DETAW", "DisALEXI", "ITRC", "SIMS", "UCD-METRIC", "UCD-PT"))+
    theme_bw() + 
    scale_fill_brewer(palette="Set3")+
    scale_y_continuous(labels = axis_units, limits = c(0, 1)) +
    ylab("% Total") +
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


pichart_TAFxCrop_PERCENT_wy_by_topcrops <- function(data, wy, aoi, select_model){
  top_crops <- c( "Rice", "Wet herbaceous/sub irrigated pasture", "Tomatoes", "Vineyards", "Semi-agricultural/ROW", "Fallow", "Pasture","Corn", "Alfalfa")
  
  af_crops_top_only <- data %>% 
    filter_no_eto() %>% 
    filter(wateryear == wy) %>% 
    filter(region == aoi) %>% 
    filter(include == "yes") %>% 
    filter(cropname %in% top_crops) %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  af_crops_others <- data %>% 
    filter_no_eto() %>% 
    filter(wateryear == wy) %>% 
    filter(region == aoi) %>% 
    filter(include == "yes") %>% 
    filter(!cropname %in% top_crops) %>% 
    mutate(cropname = "Other") %>%
    dplyr::group_by(model, cropname) %>% 
    dplyr::summarise(sum_af=sum(crop_acft))
  
  #  merge af_crops_top_only and af_crops_others
  af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)
  
  
  # filter by methods
  af_crops_w_other_single <- af_crops_w_others %>% filter(model == select_model)
  
  ggplot(af_crops_w_other_single, aes(x="", y=sum_af, fill=cropname))+
    geom_bar(width = 1, stat="identity")+ 
    ggtitle(toupper(select_model))+
    coord_polar("y") +
    theme_bw() + 
    scale_fill_brewer(palette="Set3")+
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      panel.border = element_blank(),
      panel.grid = element_blank(),
      plot.title = element_text(hjust = 0.5),
      axis.ticks = element_blank(),
      axis.text.x = element_blank(), # plot labels
      legend.position="bottom", # position of legend or none
      legend.direction="horizontal", # orientation of legend
      legend.title= element_blank(), # no title for legend
      legend.key.size = unit(0.5, "cm") # size of legend
    ) 
}  

