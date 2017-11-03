# render the figures.Rmd to the docs folder
# the docs folder pushes to gh-pages
# https://ssj-delta-cu.github.io/ssj-graphs-r/report-figures.html

rmarkdown::render('figs/figures.Rmd', 'html_document', output_file = 'report-figures.html', output_dir = 'docs')
rmarkdown::render('figs/figures-daily.Rmd', 'html_document', output_file = 'daily-figures.html', output_dir = 'docs')
rmarkdown::render('figs/figures-overpass.Rmd', 'html_document', output_file = 'overpass-figures.html', output_dir = 'docs')
rmarkdown::render('figs/appendixK.Rmd', 'html_document', output_file = 'appendixK.html', output_dir = 'docs')
rmarkdown::render('figs/spatial-cimis-eto.Rmd', 'html_document', output_file = 'spatial-cimis-eto.html', output_dir = 'docs')
rmarkdown::render('figs/field_timeseries_3x3.Rmd', 'html_document', output_file = 'field-timeseries-3x3.html', output_dir = 'docs')


