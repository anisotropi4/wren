#!/usr/bin/env node

//use data.properties.RMSect for the id
var geojsonArea = require('geojson-area');

var readline = require('readline');

var rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', function(line) {
	     //console.log(line);
	     var data = JSON.parse(line)
	     var g = data["geometry"];
	     var area = geojsonArea.geometry(g);
	     console.log(JSON.stringify({"id": data.properties.RMSect, "area_m2": area}));
});
