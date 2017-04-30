# iNterpret

  Render the 
 
## Assumptions  

  The 'iNterpret' assumes the census and geography 'ndjson' format data is in the current directory from the 'output' directory in the 'Model'  

```
$ cp ../04-Model/output/gb-census-report-density.ndjson .
$ cp ../04-Model/output/PostalSector-simple-conic.ndjson .
```

## Setup population density data  

   Calculate population density, and square-root and log values of these parameters and combine this with the geography data 

```
$ ndjson-join 'd.id' gb-census-report-density.ndjson PostalSector-simple-conic.ndjson | ndjson-map '{type: d[1].type, id: d[0].id, geometry: d[1].geometry, properties: {density_ha: d[0].density_ha, sqrt: Math.sqrt(d[0].density_ha), log: Math.log(d[0].pdensity_ha)}}' > setup/PostalSector-simple-conic-density.ndjson
```
  The 'setup.sh' script calculates these density values as well minimum and maximum parameters in the 'parameter.tsv' report  

```
$ ./setup.sh PostalSector-simple-conic
```

## Render  

  Create the PostalSector 'svg' files based on the density, square-root and log values using the 'Virdis' scale with the 'ndjson-map' and 'geo2svg' tools mapped on to a 960x960 frame. The 'domain' parameters are based on values in the 'parameters.tsv' report 

  This render is based on the 'https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c'  

```
$ < setup/PostalSector-simple-conic.ndjson ndjson-map -r d3 '(d.properties.fill = d3.scaleSequential(d3.interpolateViridis).domain([0, 515])(d.properties.density_ha), d)' | geo2svg -n --stroke none -p 1 -w 960 -h 960 > output/PostalSector-simple-conic-colours.svg
$ < setup/PostalSector-simple-conic.ndjson ndjson-map -r d3 '(d.properties.fill = d3.scaleSequential(d3.interpolateViridis).domain([0, 22.7])(d.properties.sqrt), d)' | geo2svg -n --stroke none -p 1 -w 960 -h 960 > output/PostalSector-simple-conic-sqrt-colours.svg 
$ < setup/PostalSector-simple-conic.ndjson ndjson-map -r d3 '(d.properties.fill = d3.scaleSequential(d3.interpolateViridis).domain([6.5, -2.0])(d.properties.log), d)' | geo2svg -n --stroke none -p 1 -w 960 -h 960 > output/PostalSector-simple-conic-log-colours.svg
```
  The 'render.sh' script with geography/census data file, creates 'svg' render files in the 'output' directory 
```
$ ./render.sh PostalSector-simple-conic-density  
```
The image files are then in the 'output' directory  