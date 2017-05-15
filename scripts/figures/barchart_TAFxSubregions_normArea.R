barchart_TAFxSubregions_normalizedAREA <- function(data, water_year){
  
  af <- data %>%
    filter_no_eto() %>%
    filter(wateryear == water_year) %>% 
    filter(subarea %in% c(103, 153, 1, 2, 119, 51))
  
  # TODO add data from the entire DSA region
  dsa <- data %>% 
    dplyr::group_by(model) %>%
    dplyr::summarise(WY_ACREFT=sum(WY_ACREFT, na.rm=TRUE), AREA_m=sum(AREA_m), region_name='DSA')
  
  
  # rename any areas that are "UNDESIGNATED AREA" with the subarea id
  af["subname"] <- lapply(af["subname"], as.character)
  af <- af %>% mutate(region_name=ifelse(grepl("UNDESIGNATED AREA", subname), subarea, subname))
  
  # add in the data summarized for all the DSA subregions
  af_dsa <- dplyr::bind_rows(af, dsa)
  
  
  # order of the regions
  af_dsa$region_name <- factor(af_dsa$region_name, levels=c("103", "153", "UNION ISLAND  (EAST)",
                                                    "UNION ISLAND  (WEST)", "WEBB TRACT", "STATEN ISLAND", "DSA"))
  
  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }
  
  
  # normalize acre-feet by island area
  af_area <- af_dsa %>% mutate(acftperacre=(WY_ACREFT / (AREA_m *0.000247105)))
  
  
  # custom labels to include the area
  label_area <- c("103"="103", 
                  "153"="153", 
                  "UNION ISLAND  (EAST)"="Union East",
                  "UNION ISLAND  (WEST)"="Union West", 
                  "WEBB TRACT"="Webb", 
                  "STATEN ISLAND"="Staten", 
                  "DSA"="Delta Service\nArea")
  
  # remove attributes (unit info) in order to use ggplot with area
  attributes(af_area$acftperacre) <-NULL
  
  p <- ggplot(fortify(af_area), aes(x=region_name, y=acftperacre, fill=model))+
    geom_bar(stat = "identity", position='dodge') +
    scale_x_discrete(labels=label_area)+
    theme_bw() +
    scale_fill_manual(values=model_palette, labels=methods_named_list)+
    scale_y_continuous(labels = axis_units) + #, limits = c(0, 300000)) +
    ylab("Acre-Feet per Acre") +
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

# 
# source('scripts/helper_functions.R')
# data <- readRDS('data/subregions/subregions_20170509.rds')
# water_year <- 2016
# p <- barchart_TAFxSubregions_normalizedAREA(data, water_year)
# p




