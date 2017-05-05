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
