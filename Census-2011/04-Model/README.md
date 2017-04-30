# Model

This Model section closely follows Mike Bostock's approach in his article 'Command Line Cartography' here https://medium.com/@mbostock/command-line-cartography-part-1-897aa8f8ca2c. Errors or omissions are my own

## Assumptions

The Model section assumes the following programs and modules are installed  
  * The 'gb-census-report.tsv' and 'PostalSector.json' files are in the current directory having previously been created in the '03-Explore' directory
  * As before 'nodejs' and 'jq' are installed  
  * The 'd3-geo-projection' and 'geojson-area' modules for 'nodejs' are installed  
```
$ sudo npm install -g d3-geo-projection
$ npm install geojson-area
```
   * The 'csvkit' python module here https://csvkit.readthedocs.io/en/1.0.2/index.html
```
$ pip install csvkit
```

## Create geography and census data in 'ndjson' format  

  Setup the base geography and census data in the 'setup' directory ahead of simplication and conic projection for map-rendering. The steps in this section are contained in the 'setup.sh' script  

### Geography 'ndjson' format files  

  Create the 'PostalSector.ndjson' file from the 'PostSector.json' with the 'jq' tool  

```
$ < PostalSector.json jq -c '.features[]' > setup/PostalSector.ndjson
```

  Optionally, copy the 'ndjson' into the 'run' directory to save processing the 'PostalSector.json' file twice  
```
$ cp setup/PostalSector.ndjson run/
```
  
  Based on shapefile data, calculate the area of the Sector  
```
$ < run/PostalSector.ndjson ./areas.sh > setup/PostalSector-areas.ndjson
```

### Census and density data 'ndjson' format files  

  Create an 'ndjson' format census file, ordered by 'id' field  
```
  $ < gb-census-report.tsv csvjson -t | jq -c 'sort_by(.id)' | jq -c '.[]' > setup/gb-census-report.ndjson  
```

  Based on the census data, calculate the population (density_ha), and nominal population (pdensity_ha) densities per Hectares  
```
  $ ndjson-join 'd.id' setup/PostalSector-areas.ndjson setup/gb-census-report.ndjson | \
   ndjson-map '{id: d[0].id, \
area_m2: d[0].area_m2, \
area_ha: d[1].area_ha, \
population: d[1].population, \
density_ha: d[1].population / ((d[1].area_ha == 0) ? Math.ceil(d[0].area_m2 / 10000.0) : d[1].area_ha), \
pdensity_ha: Math.max(1.0, +d[1].population) / ((d[1].area_ha == 0) ? Math.ceil(d[0].area_m2 / 10000.0) : d[1].area_ha)}' \
> output/gb-census-report-density.ndjson
```

  To allow for 'zero-population' PostalSector the 'pdensity_ha' is based on a nominal population of 1   

## Create geography and census data in the 'ndjson' format  

  Process, simplify and projection data ahead of map-visualisation, with temporary files in the 'run' directory and result files the 'output' file. The steps in this section are summaried in the 'run.sh' script with the name of the 'ndjson' format geography data
```
$ ./run.sh PostalSector
```

### Geography 'ndjson' format files  

  (Optionally) create the 'PostalSector.ndjson' file from the 'PostSector.json' with the 'jq' tool  

```
$ < PostalSector.json jq -c '.features[]' > setup/PostalSector.ndjson
```

### Tag the geography data with the **id**  

   Add the 'id' tag based on the 'properties.RMSect' to the geography data
```
$ < run/PostalSector.ndjson ndjson-map 'd.id = d.properties.RMSect, d' > run/PostalSector-id.ndjson
```

### Simplify the geography data  

  Simplify the large PostalSector geography data  

```
$ < run/PostalSector-id.ndjson geo2topo -n tracts=- | toposimplify -s 2.5E-10 -F | topo2geo -n tracts=- > run/PostalSector-topo.ndjson

```
  1 Hectare (100x100m^2) is about 2.5x10^-10 Steradians

### Data projection

   Calculate a conic equal-area geography projection file in the 'output' directory, on a 960x960 canvas between the longitude (Great Britain is between 49°N and 69°N) with the 'geoproject' tool  

```
$ < run/PostalSector-topo.ndjson jq -s -c '{"type": "FeatureCollection", "features": .}' | geoproject 'd3.geoConicEqualArea().parallels([49, 61]).rotate([0, 0, 0]).fitSize([960, 960], d)' | jq -c '.features[]' > output/PostalSector-conic.ndjson
```

### Simplify the geography data  

   Simplify the 1 pixel and quantize the geography data into the 'output' directory, with the 'geo2topo' tool  

```
$ < output/PostalSector-conic.ndjson geo2topo -n tracts=- | toposimplify -p 1 -f | topo2geo -n tracts=- > output/PostalSector-simple-conic.ndjson
$ < output/PostalSector-simple-conic.ndjson geo2topo -n tracts=- | topoquantize 1E6 | topo2geo -n tracts=- > output/PostalSector-quantized-conic.ndjson
```

### Render the geography data
   
   (Optionally) render the geography to 'svg' files into 

```
$ geo2svg -n -w 960 -h 960 output/PostalSector-conic.ndjson > PostalSector-conic.svg
$ geo2svg -n -w 960 -h 960 output/PostalSector-simple-conic.ndjson > PostalSector-simple-conic.svg
$ geo2svg -n -w 960 -h 960 output/PostalSector-quantized-conic.ndjson > PostalSector-quantized-conic.svg
```

