

scatter_highNDVIETxCIMISETo <- function(data){

  valid_data = data %>% filter(model_et_highNDVI_mean > 0, !is.na(model_et_highNDVI_mean), !is.na(DayAsceEtoValue))
  valid_data$DayAsceEtoValue = valid_data$DayAsceEtoValue * 10  # correct the ETo so it's in 10ths of mm
  
  # correct UCD-PT values downward
  valid_data <- mutate(valid_data, model_et_highNDVI_mean = ifelse(model == "ucdpt", model_et_highNDVI_mean / 10, model_et_highNDVI_mean))

  # correct ITRC-METRIC Values upward
  valid_data <- mutate(valid_data, model_et_highNDVI_mean = ifelse(model == "itrc", model_et_highNDVI_mean * 10, model_et_highNDVI_mean))
  
  axis_limit <- max(max(valid_data$model_et_highNDVI_mean), max(valid_data$DayAsceEtoValue)) 
  axis_min <-min(min(valid_data$model_et_highNDVI_mean), min(valid_data$DayAsceEtoValue))
  
  p <- ggplot(valid_data, aes(x=DayAsceEtoValue, y=model_et_highNDVI_mean, color=model))+geom_point(size=2.5)+
    ggtitle("CIMIS Stations vs. Model Mean Estimated ET for High NDVI Locations")+
    ylab(paste("Model Estimated Alfalfa ET", "\n", "(10th mm/day)", sep=""))+
    xlab(paste("CIMIS Station Alfalfa ETo", "\n", "(10th mm/day)", sep=""))+
    coord_cartesian(xlim = c(axis_min,axis_limit), ylim=c(axis_min, axis_limit))+
    theme_bw()+
    geom_abline(intercept = 0, slope = 1, colour="black", linetype="dashed", size=2.25, alpha=0.5)+ #1:1 diagonal line
    theme(panel.border = element_blank(), panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5, size=16),
          panel.grid.minor = element_blank(),
          legend.position="bottom", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"),
          axis.text.y=element_text(size=14),
          axis.text.x=element_text(size=14),
          axis.title.y=element_text(size=14),
          axis.title.x=element_text(size=14),
          axis.line = element_line(color="black", size=1)
    )
  p
}