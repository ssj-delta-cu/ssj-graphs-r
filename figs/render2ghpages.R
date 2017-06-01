# render the figures.Rmd to the docs folder
# the docs folder pushes to gh-pages
# https://ssj-delta-cu.github.io/ssj-graphs-r/report-figures.html

rmarkdown::render('figs/figures.Rmd', 'html_document', output_file = 'report-figures.html', output_dir = 'docs')

