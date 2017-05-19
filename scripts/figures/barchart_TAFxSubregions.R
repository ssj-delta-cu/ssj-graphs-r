barchart_TAFxSubregions <- function(data, water_year){

  af <- data %>%
    filter_no_eto() %>%
    filter(wateryear == water_year) %>% 
    filter(subarea %in% c(103, 153, 1, 2, 119, 51))
  
  
  # rename any areas that are "UNDESIGNATED AREA" with the subarea id
  af["subname"] <- lapply(af["subname"], as.character)
  af <- af %>% mutate(region_name=ifelse(grepl("UNDESIGNATED AREA", subname), subarea, subname))
  
  
  # order of the regions
  af$region_name <- factor(af$region_name, levels=c("103", "153", "UNION ISLAND  (EAST)",
                                                   "UNION ISLAND  (WEST)", "WEBB TRACT", "STATEN ISLAND"))
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  # custom labels to include the area
  label_area <- c("103"="103\n(34,140 acres)", 
                  "153"="153\n(13,800 acres)", 
                  "UNION ISLAND  (EAST)"="Union East\n(11,850 acres)",
                  "UNION ISLAND  (WEST)"="Union West\n(13,700 acres)", 
                  "WEBB TRACT"="Webb\n(5,500 acres)", 
                  "STATEN ISLAND"="Staten\n(9,600 acres)")

  p <- ggplot(af, aes(x=region_name, y=WY_ACREFT, fill=model))+geom_bar(stat = "identity", position='dodge') +
    scale_x_discrete(labels=label_area)+
    theme_bw() +
    ggtitle(paste("Water Year ", water_year))+
    scale_fill_manual(values=model_palette, labels=methods_named_list)+
    scale_y_continuous(labels = axis_units) + #, limits = c(0, 300000)) +
    ylab("Thousand Acre-Feet") +
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
          axis.line.y = element_line(color="black", size = 1))  # manually add in axis
  p}


# source('scripts/helper_functions.R')
# data <- readRDS('data/subregions/subregions_20170509.rds')
# water_year <- 2016
# p <- barchart_TAFxSubregions(data, water_year)
# p

