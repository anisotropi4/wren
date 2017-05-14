# Explore, Model and iNterpret

  This is where the Train-Time and Lower Layer Super Output Areas geography datais combined and rendered  

  The 'run.sh' script contains the script elements of the data  

### Combine Rail Train-Time and Super Output Areas geography data  

   Create the 'topo.json' topoJSON file format by combinging the Rail Train-Time and Super Output Area geography data and render against a Conic Equal Area projection on a 960 x 640 canvas. This uses the 'geo2topo', 'geoproject', 'ndjson-map', 'toposimplify', 'topoquantize' and 'jq' tools in the pipeline

```
$ geo2topo -n tracts=<(ndjson-join 'd.id' \
    <(jq -c 'select(.CRS=="'${CRS}'") | del(.CRS) | to_entries | map ({id: .key, time: .value})[]' Stations_HW_AM.ndjson) \
    <(jq -s -c '{"type": "FeatureCollection", "features": .}' LLSOA-2001-England-and-Wales.ndjson | \
    geoproject "d3.geoConicEqualArea().parallels([49, 61]).fitSize(['640','960'], d)" | \
    jq -c '.features[]') | \
    ndjson-map -r d3 '{type: d[1].type, properties: {title: d[0].id, time: d[0].time}, geometry: d[1].geometry}') | \
    toposimplify -p 1 -f | \
    topoquantize 1E6 > topo.json
```

### Render the data  

   Render the data into the 'topo.svg' vector image file using the 'ndjson-map' tool to split the time in 30-minute graduations upto five-hours, 'ndjson-map' to colour using the 'schemeSpectral' colour scheme and 'geo2svg'   

```
$ < topo.json topo2geo -n tracts=- | \
    ndjson-map -r d3=d3 '(d.properties.scale=d3.bisect([30, 60, 90, 120, 150, 180, 210, 240, 270, 300],d.properties.time),d)' | \
    ndjson-map -r d3=d3-scale-chromatic '(d.properties.fill=d3.schemeSpectral[11][d.properties.scale], d)' | \
    geo2svg --stroke=none -n -p 1 -w 640 -h 960 > topo.svg  
```

   This creates the static SVG file for York
