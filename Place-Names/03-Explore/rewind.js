#!/usr/bin/env node

const d3 = require('d3-geo');
const fs = require('fs');

function rewind(d) {
  for(var i=0; i < d.length; i++ ) {
    d[i].geometry
      .coordinates
      .forEach(function(coordinate) {
        var polygon = {type: "FeatureCollection", features: [{type: "Feature", geometry: {type: "Polygon", coordinates: coordinate}}]};
        if (d3.geoArea(polygon) > 2 * Math.PI) {
          //console.log(d[i].properties.name);
          coordinate.forEach(function(ring) {
            ring.reverse();
          })
        }
      });
  }
}

function readJSON(filename) {
  var data = fs.readFileSync(filename, 'utf8', function(err, d) {  
    if (err) throw err;
    return d;
  });
  return JSON.parse(data);
}

var multipolygons = readJSON(0);

rewind(multipolygons.features);
 
fs.write(1, JSON.stringify(multipolygons) + '\n', function (err) {
	  if (err) throw err;
});
