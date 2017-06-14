# create a dispersion grid showing absolute variation across models


# aad() returns the average (mean) absolute deviation from the sample mean.
# I'd have called this function mad() but that's taken by a slightly different
# function
aad <- function(x, na.rm = FALSE) { 
  if ( !is(x,"numeric") & !is(x,"integer") ) {
    stop( '"x" must be numeric')
  }
  if( !is(na.rm,"logical") | length(na.rm) !=1 ) {
    stop( '"na.rm" must be a single logical value')
  }
  if (na.rm) { x <- x[!is.na(x)] }
  y <- mean( abs(x - mean(x)) )
  return(y)
}



absolute_variation_grid <- function(data, water_year){

  # list of crops to include
  c_list <- c("Alfalfa", "Almonds", "Corn", "Pasture", "Potatoes", "Rice",  "Tomatoes", "Vineyards")
  c_list <- sort(c_list, decreasing=TRUE)
  
  # transform data so that we get the std across models by crop type
  data_grid <- data %>% 
    filter(wateryear == water_year) %>% 
    filter_no_eto() %>% 
    group_by(month, level_2, cropname) %>%
    summarise(sd=sd(mean/10), mean_mm=mean(mean/10), cv=sd/mean_mm, absvar=aad(mean/10)) %>%
    filter(cropname %in% c_list)
  
  # TODO add column to the grid for the annual total?
  
  # change the orders of the factor levels so axis are in the right order
  data_grid$cropname <- factor(data_grid$cropname, levels=c_list)
  data_grid$month <- factor(data_grid$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))
  
  p <- ggplot(data_grid, aes(month, cropname))+
    geom_tile(data=data_grid, aes(fill=absvar), color="white")+
    scale_fill_gradient2(low="green", high="red", mid="yellow", 
                         midpoint=0.75, limit=c(0,1.5),name="SD")+
    geom_text(aes(label=sprintf("%0.2f", round(absvar,2))), size=3)+
    coord_equal()+
    ggtitle(paste("Water Year ", water_year, "\nAbsolute Variation (mm/day)", sep=""))+
    theme_bw() +  # change theme simple with no axis or tick marks
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          legend.position="bottom", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(1.0, "cm"),
          axis.text.x=element_text(size=10),
          axis.text.y=element_text(size=10)
          )
  
    p
}

