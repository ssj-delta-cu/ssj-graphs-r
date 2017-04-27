# Code for creating report graphs in R

Porting over all figures that were created using google sheets. R allows for more flexibility and transparency.

## Reqs

R
  - ggplot
  - dplyr
  - plyr
  - rjson

## Input Data

All data for the charts and figures are exported from Google Earth Engine as .json file (see et_comparisons.js for more info).

## Color Standards

### Modeling Groups

|Color| HEX | Group |
| --- | --- | ----- |
|![#3366cc](https://placehold.it/15/3366cc/000000?text=+) |`#3366cc`| CalSIMETAW |
|![#dc3912](https://placehold.it/15/dc3912/000000?text=+) |`#dc3912`| DETAW |
|![#ff9900](https://placehold.it/15/ff9900/000000?text=+) |`#ff9900`| DisALEXI |
|![#109618](https://placehold.it/15/109618/000000?text=+) |`#109618`| ITRC |
|![#990099](https://placehold.it/15/990099/000000?text=+) |`#990099`| SIMS |
|![#0099c6](https://placehold.it/15/0099c6/000000?text=+) |`#0099c6`| UCD-Metric |
|![#dd4477](https://placehold.it/15/dd4477/000000?text=+) |`#dd4477`| UCD-PT |


### Crops types

|Color| HEX | Crop |
| --- | --- | ----- |
|![#00b838](https://placehold.it/15/00b838/000000?text=+) |`#00b838`| Alfalfa |
|![#d8813a](https://placehold.it/15/d8813a/000000?text=+) |`#d8813a`| Almonds |
|![#ffdf50](https://placehold.it/15/ffdf50/000000?text=+) |`#ffdf50`| Corn |
|![#f5a27a](https://placehold.it/15/f5a27a/000000?text=+) |`#f5a27a`| Fallow |
|![#c4ac80](https://placehold.it/15/c4ac80/000000?text=+) |`#c4ac80`| Pasture |
|![#916e46](https://placehold.it/15/916e46/000000?text=+) |`#916e46`| Potatoes |
|![#9e5123](https://placehold.it/15/9e5123/000000?text=+) |`#9e5123`| Rice |
|![#de2513](https://placehold.it/15/de2513/000000?text=+) |`#de2513`| Tomatoes |
|![#6a3387](https://placehold.it/15/6a3387/000000?text=+) |`#6a3387`| Vineyards |
|![#96c990](https://placehold.it/15/96c990/000000?text=+) |`#96c990`| Other Crops |
|![#267300](https://placehold.it/15/267300/000000?text=+) |`#267300`| Native Vegetation |
|![#397dea](https://placehold.it/15/397dea/000000?text=+) |`#397dea`| Water |
|![#b2b2b2](https://placehold.it/15/b2b2b2/000000?text=+) |`#b2b2b2`| Urban |
