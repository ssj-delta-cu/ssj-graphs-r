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
|![#267300](https://placehold.it/15/267300/000000?text=+) |`#267300`|  |  Native Vegetation |
|![#397dea](https://placehold.it/15/397dea/000000?text=+) |`#397dea`|  |  Water |
|![#b2b2b2](https://placehold.it/15/b2b2b2/000000?text=+) |`#b2b2b2`|  |  Urban |
