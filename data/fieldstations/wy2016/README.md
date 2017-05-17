# Full 2017-05-17

Data processed with ssj-delta-et/ssj-overview/et_fieldpts_wy2016.js 

## Results

Groups missing are detaw and calsimetaw

Still waiting on ITRC to see which version of results to use in the report. For the time being, using
itrc_co as ITRC's data since one of the raster for itrc_or has 13 bands (https://github.com/ssj-delta-cu/ssj-itrc-metric/issues/4)


## EE script with paths to asset sources 

```
// get the value at each of the field stations for each month in the 12 month raster

var select_water_year = function(water_year){
  if(water_year == 2015){

    var methods={
      itrc:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2015_v2-1-0")},
      //itrc_or:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2015_v2-0-1")},
      disalexi:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-disalexi/disalexi_et_wy2015_v2-1-0")},
      ucdpt:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-priestley-taylor/ucd-pt_et_wy2015_v2-2-0")},
      ucdmetric:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-metric/ucd-metric_et_wy2015_v2-0-0")},
      sims:{image: ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-sims/sims_et_wy2015_v2-0-0")},
      eto:{image: ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-weather/eto_wy2015")},
      
    };
    
    var landIQ = ee.Image('users/ucd-cws-ee-data/ssj-delta-cu/ssj-landuse/landuse_2015_v2016-06-16');
    var landcover = landIQ.select(['b2']).rename('level_2');
  }
  else if(water_year == 2016){

    var methods={
      itrc:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2016_v2-1-0")},
      //itrc_or:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-itrc-metric/itrc_et_wy2016_v2-0-1")},
      disalexi:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-disalexi/disalexi_et_wy2016_v2-1-0")},
      ucdpt:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-priestley-taylor/ucd-pt_et_wy2016_v2-2-0")},
      ucdmetric:{image:ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-ucd-metric/ucd-metric_et_wy2016_v2-0-0")},
      sims:{image: ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-sims/sims_et_wy2015_v2-0-0")},
      eto:{image: ee.Image("users/ucd-cws-ee-data/ssj-delta-cu/ssj-weather/eto_wy2016")},
      
    };
    
    var landIQ = ee.Image('users/ucd-cws-ee-data/ssj-delta-cu/ssj-landuse/landuse_2016_v2017-04-25');
    var landcover = landIQ.select(['b1']).rename('level_2');
  }
  
  return({methods: methods, landcover: landcover});
};//updated 5-17-17


// fusion table with the station points
var station_points = ee.FeatureCollection('ft:1TedFG6u5KqIKghK23OyhPQC7ZIk-H_Qy74rkBvYL');
Map.addLayer(station_points);


var reduce_station = function(image){
  
  // months in wy order
  var m = ['OCT','NOV','DEC','JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP'];
  
  // rename band to months (They are in order by water year)
  image=image.select([0,1,2,3,4,5,6,7,8,9,10,11],m);
  
  // reduce regions at all the points in the feature collection
  var MeanFeatures = image.reduceRegions({
    collection: station_points,
    reducer: ee.Reducer.mean(),
    scale: 30,
  });
  return(MeanFeatures);
};


var exportEEjson = function(wateryear){
  var methods = select_water_year(wateryear).methods;
  //loop through all the et sources, calc stats for stations
  for (var key in methods) {
    var filename = key + "-" + "fieldstation" + "-" + wateryear;
    print(filename);
    var e =  reduce_station(methods[key].image);
    Export.table.toDrive(e, filename, "ET_comparisons_geojson", filename, "GeoJSON");
    }
  
};


exportEEjson(2016);

```