#!/usr/bin/env node

const d3 = require('d3');
const fs = require('fs');

function rewind(d) {
  for(var i=0; i < d.length; i++ ) {
    d[i].geometry
      .coordinates
      .forEach(function(coordinate) {
        var polygon = {type: "FeatureCollection", features: [{type: "Feature", geometry: {type: "Polygon", coordinates: coordinate}}]};
        if (d3.geoArea(polygon) > 2 * Math.PI) {
          coordinate.forEach(function(ring) {
            ring.reverse();
          })
        }
      });
  }
}

function readNDJSON(filename) {
  var data = fs.readFileSync(filename, 'utf8', function(err, d) {  
    if (err) throw err;
    return d;
  }).split('\n');
  data.pop();
  return data.map(JSON.parse);
}

function getPointCoords(p) {
  return p['geometry']['coordinates'];
}

var points = readNDJSON('output/geo-points.ndjson');
var multipolygons = readNDJSON('output/geo-multipolygons.ndjson');

rewind(multipolygons);

var tree = d3.quadtree().x(function(d) {
  return d.geometry.coordinates[0];
}).y(function(d) {
  return d.geometry.coordinates[1];
}).addAll(points);

const nullpath = d3.geoPath().projection(null);

for (var i=0; i < multipolygons.length; i++ ) {
  var area = multipolygons[i];
  var b = nullpath.bounds(area);

  tree.visit(function(node, x1, y1, x2, y2) {
    if (!node.length) {
      if (d3.geoContains(area, getPointCoords(node.data))) {
        var v = {'county': {'name': area.properties.name, 'osm_id': area.properties.osm_id}, 'location': node.data.properties};
        fs.write(1, JSON.stringify(v) + '\n', function (err) {
        	if (err) throw err;
        })
      }
    }
    return x1 >= b[1][0] || y1 >= b[1][1] || x2 <= b[0][0] || y2 <= b[0][1];
  });
}
