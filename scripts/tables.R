# tables

source("scripts/helper_functions.R")

# summary table for figure # 5 TAF summed over water year

table_taf_wy_regions <- function(data, wy){
  # summarize total acre-ft just using crops (ie include = "yes")
  af_crops <- data %>% filter(include == "yes") %>%
    dplyr::group_by(model, region, wateryear) %>% 
    dplyr::summarise(sum_af=sum(crop_acft)) %>% filter(wateryear == wy)
  
  # manually chuck results for models that don't conver legal delta
  af_crops_filter <- af_crops %>% filter(model!="eto") %>%
    filter(model!="calsimetaw" & model!="detaw" & model!="sims" | region!="legal")
  
  # get summary table (by making data untidy)
  dsa <- af_crops_filter %>% filter(region=="dsa") %>% ungroup() %>% select(model, sum_af)
  legal <- af_crops_filter %>% filter(region=="legal") %>% ungroup() %>% select(model, sum_af)
  
  j <- full_join(dsa, legal, by="model")
  colnames(j) <- c("Method", "DSA", "LEGAL")
  j
}


