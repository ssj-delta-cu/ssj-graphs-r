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
