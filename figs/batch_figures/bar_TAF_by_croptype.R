# batch outputs bar chart figures
source('figs/batch_figures/output_settings.R')

fig_num <- 8

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)

for(y in 1:length(water_years)){
  wy <- water_years[y]
  

  p <- barchart_TAFxModel_sum_wy_by_topcrops(dsa_legal_data, wy, 'dsa')
  p


  base.ext <- paste("TAF_by_croptype_", wy, ".png", sep="")
  name <- paste(file.path(mainDir, subDir), base.ext, sep="/")
  
  # save
  ggsave(name, p, width=7, height=4, units="in")
  print(name)
}  