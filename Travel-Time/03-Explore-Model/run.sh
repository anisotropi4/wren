#!/bin/sh -x
# Train travel-time data

if [ ! -f Stations_HW_AM.ndjson ]
then
   ln ../02-Scrub/Stations_HW_AM.ndjon
fi

if [ ! -f LLSOA-2001-England-and-Wales.ndjon ]
then
   ln ../02-Scrub/LLSOA-2001-England-and-Wales.ndjon
fi

if [ ! -s topo.json ]
then
    geo2topo -n tracts=<(ndjson-join 'd.id' \
        <(jq -c 'select(.CRS=="'${CRS}'") | del(.CRS) | to_entries | map
({id: .key, time: .value})[]' Stations_HW_AM.ndjson) \
        <(jq -s -c '{"type": "FeatureCollection", "features": .}' LLSOA-
2001-England-and-Wales.ndjson | \
    geoproject "${PROJECTION}" | \
    jq -c '.features[]') | \
        ndjson-map -r d3 '{type: d[1].type, properties: {title: d[0].id, time: d
[0].time}, geometry: d[1].geometry}') | \
        toposimplify -p 1 -f | \
        topoquantize 1E6 > topo.json
fi

< topo.json topo2geo -n tracts=- | \
    ndjson-map -r d3=d3 '(d.properties.scale='"${SCALE}"',d)' | \
    ndjson-map -r d3=d3-scale-chromatic '(d.properties.fill='"${FILL}"', d)' | \
    geo2svg --stroke=none -n -p 1 -w ${WIDTH} -h ${HEIGHT} | \
    sed '$d' > topo.svg  
