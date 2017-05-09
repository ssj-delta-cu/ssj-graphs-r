# Full 2017-05-09

Data processed with ssj-delta-et/ssj-overview/et_comparisons_2json.js for the legal delta and the delta service area.

## inital results for both water years

Groups missing are detaw and calsimetaw

Both DisAlexi and ITRC have two versions to compare.

## Asset sources 

```
var select_water_year = function(water_year){
  if(water_year == 2015){

    var methods={
      itrc_co:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2015_v2-1-0")},
      itrc_or:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2015_v2-0-1")},
      disalexi_or:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-disalexi/disalexi_et_wy2015_v2-0-0")},
      disalexi_co:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-disalexi/disalexi_et_wy2015_v2-1-0")},
      ucd_pt:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-priestley-taylor/ucd-pt_et_wy2015_v2-1-0")},
      ucd_metric:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-metric/ucd-metric_et_wy2015_v2-0-0")},
      };
    
    var landIQ = ee.Image('users/ucd-cws-ee-data/ssj-delta-cu/ssj-landuse/landuse_2015_v2016-06-16');
    var landcover = landIQ.select(['b2']).rename('level_2');
  }
  else if(water_year == 2016){

    var methods={
      itrc_co:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2016_v2-1-0")},
      itrc_or:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2016_v2-0-1")},
      disalexi_or:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-disalexi/disalexi_et_wy2016_v2-0-0")},
      disalexi_co:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-disalexi/disalexi_et_wy2016_v2-1-0")},
      ucdpt:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-priestley-taylor/ucd-pt_et_wy2016_v2-1-0")},
      ucd_metric:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-metric/ucd-metric_et_wy2016_v2-0-0")},
    };
    
    var landIQ = ee.Image('users/ucd-cws-ee-data/ssj-delta-cu/ssj-landuse/landuse_2016_v2017-04-25');
    var landcover = landIQ.select(['b1']).rename('level_2');
  }
  
  return({methods: methods, landcover: landcover});
};