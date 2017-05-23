# render the Rmd notebooks in the Rmd folder to the docs folder
# the docs folder pushes to gh-pages
# https://ssj-delta-cu.github.io/ssj-graphs-r/notebook-name.html

f <- 'figs/Rmd/sims.Rmd'

rmd_files <- list.files('figs/Rmd', pattern=".Rmd", full.names = T)

for(f in rmd_files){
  rmarkdown::render(f, 'html_document', output_dir = 'docs')
}

