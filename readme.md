# Code for creating report graphs in R

This repository contains the code used to make figures and graphs in the
Sacramento San-Joaquin Delta Consumptive Use reports, starting with the interim report (preliminary results for the 2015-2016 water year). Code for 2014-2015 water year report figures were initially produced in Google
Sheets but for the final report figures were generated using the R code base included in this repository. Code to make maps is in the repository [ssj-data-viz](ssj-data-viz).

## General Procedure
As a quick overview of the process, generating graphs and figures involves
the following:

* Retrieving data from the various modeling groups
* Processing that data to monthly rasters, as appropriate and uploading
those data to Earth Engine
* Running Earth Engine-based scripts that output necessary data tables for
graphs
* Downloading those data tables to directories within this repository
* Running a R-Markdown file that generates all of the graphs
* Manually inserting generated graphs into the report

For a detailed overview of the process for creating the graphs as of mid-2017,
see [this full video training](https://ucdavis.box.com/s/pyg3m4xr8jhx1sen2scxfh10zukt5hsj).

## Requirements

R
  - ggplot
  - dplyr
  - plyr
  - rjson
  - tidyr
  - tidyverse
  - sf
  - jsonlite
  - geosphere
  - lazyeval

Access to Earth Engine

## Specific Procedure
Again, for a detailed overview of the process for creating the graphs as of mid-2017,
see [this full video training](https://ucdavis.box.com/s/pyg3m4xr8jhx1sen2scxfh10zukt5hsj).

### Retrieve Data from Modeling Groups
The first step is to obtain data from each modeling group. This process will vary by group and their data format, but some groups will upload their data directly to GitHub, some prefer delivering via FTP, and others prefer sending some other form of link, such as a Google Drive folder. See each individual group repository for more information about this process (a lot of the notes about the process are documented as GitHub issues so make sure to check for in closed issues). This portion of the process isn't usually too complicated, though for groups that deliver via GitHub, be careful that they don't commit daily rasters, especially not in multiple versions as it can use up our GitHub LFS allocation very quickly.

### Process Data to Monthly Rasters
Once the data have been retrieved, they need to be processed into monthly
rasters. Some groups will deliver monthly data, so this step can be skipped
for those groups, but others will deliver daily data (DisALEXI) or landsat
date data (UCD METRIC). Each of these models has a different procedure for
generating monthly rasters.

#### DisALEXI
DisAlexi provided daily ET data which is downloaded via a ftp (note: copies of all the raw DisAlexi data are on the CWS servers at `X:\ssj-delta-cu\Code\ssj-disalexi`). Please see the notes [Upload disalexi data into Earth Engine / Compute Monthly summaries ](https://github.com/ssj-delta-cu/ssj-disalexi/issues/1) issue for more information about converting the `.hdr` rasters and uploading them to an EarthEngine imageCollection. Once all the images are in an EarthEngine imageCollection, use the EarthEngine script [`ssj-delta-et/ssj-disalexi/daily_to_monthly.js`](https://code.earthengine.google.com/44dc8c780f176b6056b6fa41592992d6) to create the 12 band monthly ET raster for each water year.

#### UCD-METRIC
UCD-Metric provided images by landsat date. The EarthEngine script to interpolate the monthly values from the overpass images can be found at [`ssj-delta-cu/ssj-ucd-metric/landsat_to_monthly.js`](https://code.earthengine.google.com/8eb5d61a520fdae6d74284f1abc5640f).

TODO: this script should be moved over to the `ssj-delta-et` repository on EarthEngine that is owned by the CWS shared account. `ssj-delta-cu` is depreciated.


#### Uploading Data to Earth Engine
Regardless, for all models, data should be uploaded to Earth Engine.
We keep Earth Engine data in a shared account (ucd-cws-ee-data@gmail.com)
that allows assets to be
jointly managed. We do this, rather than uploading to individual accounts
and sharing because when a staff changeover occurred, it was a nightmare
to get assets needed for model runs reshared. Keeping the assets in a shared
account, with a shared username and password in a database managed by CWS
It minimizes these problems as we always have someone on staff with direct
access to the assets.

## Input Data

All data for the charts and figures are exported from Google Earth Engine as .json file (see et_comparisons.js for more info). These files are then processed in R to standardize data and add additional attributes (ie crop names and the number of days in the month). The tidy results are then saved to disk which is then used to build the plots and figures.


### Overview of the EarthEngine Scripts

#### `ssj-delta-et/ssj-overview/et_comparisons.js`

This is the main script for analyzing the monthly ET data. The script runs through all the landuse types and calculates various statistics for a given area of interest (Delta Service Area or Legal Delta). The .json export contains the landuse type, the count of the number of cells in the region of interest, the mean daily ET value for the month, the median ET value, the value of the 9th, 25th, 75th & 91th percentiles. Script creates a task for each model to export, so make sure to start the process in the Tasks tab.

#### `ssj-delta-et/ssj-overview/et_comparisons_regional.js`

Similar to et_comparisons.js but includes several additional subregions for analysis (South, North, Central, Yolo, West).

#### `ssj-delta-et/ssj-overview/et_fieldpoints.js`

Extracts the monthly ET value at each of the fieldstations. This is depreciated since the final report used the daily values for the overpass days (see daily_charts).

#### `ssj-delta-et/ssj-overview/et_comparisons_subregions_cropmask.js`

Summarizes the agricultural area only (all non-ag landuses are masked) for all 168 DETAW subregions.

#### `ssj-delta-et/ssj-overview/etrf_comparisons_2json.js`

Calculates ETrF (EToF) per pixel by dividing the monthly ET by monthly reference ETo. Spatial CIMIS was used as the ETo reference for the models except when the modeling group provided their own reference ETo.

#### `ssj-delta-et/daily_charts/*_daily`

Scripts to produce daily time series for the models that were able to provide additional data for the overpasses and/or the daily interpolated values between the overpass dates. Values are extracted from the raster stack at the 3x3 grid around the field stations as well as for the CIMIS stations. Function can export Rn values as well as ET.

### Data Post Processing

The .json files from EarthEngine are parsed and cleanup in `data/data_postprocessing.Rmd`.


## Color Standards

### Modeling Groups

|Color| HEX | rgb |Group |
| --- | --- | ---- | ----- |
|![#0072b2](https://placehold.it/15/0072b2/000000?text=+) |`#0072b2`| rgb(0, 114, 178) | CalSIMETAW |
|![#d55e00](https://placehold.it/15/d55e00/000000?text=+) |`#d55e00`| rgb(213, 94, 0) | DETAW |
|![#e69f00](https://placehold.it/15/e69f00/000000?text=+) |`#e69f00`| rgb(230, 159, 0) | DisALEXI |
|![#009e73](https://placehold.it/15/009e73/000000?text=+) |`#009e73`| rgb(0, 158, 115) | ITRC |
|![#cc79a7](https://placehold.it/15/cc79a7/000000?text=+) |`#cc79a7`| rgb(204, 121, 167) | SIMS |
|![#56b4df](https://placehold.it/15/56b4df/000000?text=+) |`#56b4df`| rgb(86, 180, 223) | UCD-Metric |
|![#f0e442](https://placehold.it/15/f0e442/000000?text=+) |`#f0e442`| rgb(240, 228, 66) | UCD-PT |


### Crops types

|Color| HEX | rgb |Crop |
| --- | --- | ----- | ----- |
|![#0ab54e](https://placehold.it/15/0ab54e/000000?text=+) |`#0ab54e`| rgb(10, 181, 78) | Alfalfa |
|![#feaca7](https://placehold.it/15/feaca7/000000?text=+) |`#feaca7`| rgb(254, 172, 167 | Almonds |
|![#fffb58](https://placehold.it/15/fffb58/000000?text=+) |`#fffb58`| rgb(255, 251, 88)  | Corn |
|![#fe9a2f](https://placehold.it/15/fe9a2f/000000?text=+) |`#fe9a2f`| rgb(254, 154, 47) |  Fallow |
|![#ffc98b](https://placehold.it/15/ffc98b/000000?text=+) |`#ffc98b`| rgb(255, 201, 139) | Pasture |
|![#c7b8dc](https://placehold.it/15/c7b8dc/000000?text=+) |`#c7b8dc`| rgb(199, 184, 220) |  Potatoes |
|![#99cbee](https://placehold.it/15/99cbee/000000?text=+) |`#99cbee`| rgb(153, 203, 238) | Rice |
|![#e44746](https://placehold.it/15/e44746/000000?text=+) |`#e44746`| rgb(228, 71, 70)  | Tomatoes |
|![#7b5baa](https://placehold.it/15/7b5baa/000000?text=+) |`#7b5baa`| rgb(123, 91, 170) | Vineyards |
|![#b3dda5](https://placehold.it/15/b3dda5/000000?text=+) |`#b3dda5`| rgb(179, 221, 165) |  Other Crops |
|![#d7d79e](https://placehold.it/15/d7d79e/000000?text=+) |`#d7d79e`| rgb(215, 215, 158) |  Native Vegetation |
|![#6699cb](https://placehold.it/15/6699cb/000000?text=+) |`#6699cb`| rgb(102, 153, 203) |  Water |
|![#b2b2b2](https://placehold.it/15/b2b2b2/000000?text=+) |`#b2b2b2`| rgb(178, 178, 178) |  Urban |
