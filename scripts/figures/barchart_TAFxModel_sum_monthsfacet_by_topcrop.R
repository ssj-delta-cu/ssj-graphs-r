barchart_TAFxModel_sum_monthsfacet_by_topcrop <- function(data, water_year, aoi){

  #top_crops <- c("Alfalfa", "Almonds",  "Corn", "Fallow", "Pasture", "Potatoes", "Rice",  "Tomatoes", "Vineyards")
  top_crops <- c("Alfalfa", "Corn",  "Pasture", "Tomatoes", "Vineyards")

  af_crops_top_only <- data %>%
    filter_no_eto() %>%
    filter(wateryear == water_year) %>%
    filter(region == aoi) %>%
    filter(include == "yes") %>%
    filter(cropname %in% top_crops) %>%
    dplyr::group_by(model, cropname, month) %>%
    dplyr::summarise(sum_af=sum(crop_acft))

  af_crops_others <- data %>%
    filter_no_eto() %>%
    filter(wateryear == water_year) %>%
    filter(region == aoi) %>%
    filter(include == "yes") %>%
    filter(!cropname %in% top_crops) %>%
    mutate(cropname = "Other") %>%
    dplyr::group_by(model, cropname, month) %>%
    dplyr::summarise(sum_af=sum(crop_acft, na.rm = TRUE))

  #  merge af_crops_top_only and af_crops_others
  af_crops_w_others <- dplyr::union(af_crops_top_only, af_crops_others)

  # modify axis units (acre-ft -> thousands acre-feet)
  axis_units <-function(x){
    x/1000
  }

  # change order of months to follow water year Oct -> Sept
  af_crops_w_others$month <- factor(af_crops_w_others$month, levels=c("OCT", "NOV", "DEC", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP"))

  p <- ggplot(af_crops_w_others, aes(x=model, y=sum_af, fill=cropname))+geom_bar(stat = "identity") +
    facet_grid(. ~ month)+
    scale_x_discrete(limit=c("calsimetaw", "detaw", "disalexi", "itrc", "sims", "ucdmetric", "ucdpt"), labels=methods_named_list)+
    theme_bw() +
    ggtitle(paste("Water Year", water_year))+
    scale_fill_manual(values=crop_palette)+
    scale_y_continuous(labels = axis_units, limits = c(0, 300000)) +
    ylab("Thousand Acre-Feet") +
    theme(#panel.border = element_blank(),
          panel.grid.major = element_blank(),
          plot.title = element_text(hjust = 0.5),
          panel.grid.minor = element_blank(),
          axis.title.x = element_blank(),
          axis.text.x=element_text(angle=90, hjust=1, vjust=0.5),
          legend.position="bottom", # position of legend or none
          legend.direction="horizontal", # orientation of legend
          legend.title= element_blank(), # no title for legend
          legend.key.size = unit(0.5, "cm"))+ # size of legend
          theme(strip.background = element_blank(), strip.placement = "outside",
                axis.line.x = element_line(color="black", size = 1),
                axis.line.y = element_line(color="black", size = 1))
    p}

#barchart_TAFxModel_sum_monthsfacet_by_topcrop(dsa_legal_data_wo_wetsemi, 2016, 'dsa')