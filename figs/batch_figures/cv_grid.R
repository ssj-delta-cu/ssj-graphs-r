# coeffient of variation grid
source("figs/batch_figures/output_settings.R")
fig_num <- 24

# make an ouput folder for the figure
mainDir <- getwd()
subDir <-paste("figs/fig", fig_num, sep="")
ifelse(!dir.exists(file.path(mainDir, subDir)), dir.create(file.path(mainDir, subDir)), FALSE)


# loop through both water years and save the figure
for(y in 1:length(water_years)){
  wy <- water_years[y]
  
  p <- coefficient_variation_grid(dsa_legal_data, wy)
  
  # add footer
  p <- p + labs(caption=footer)
  
  # build name for export
  base <- paste("CV_grid_", wy, ".png", sep='')
  name <- paste(file.path(mainDir, subDir), base, sep="/")
  
  # save
  ggsave(name, p, width=6, height=5, units="in")
  print(name)

}