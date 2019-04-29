#!/bin/sh

if [ ! -d output ]; then
    mkdir output
fi

if [ ! -f output/british-isles.json ]; then
    ln ../03-Explore/output/british-isles.json output/british-isles.json
fi

for i in points multipolygons
do
    if [ ! -f output/geo-${i}.ndjson ]; then
        ln ../02-Scrub/output/geo-${i}.ndjson output/geo-${i}.ndjson
    fi
done

# This method uses a script based on d3 to see whether a point 'is in' a
# GeoJSON polygon/multipolygon
if [ ! -f output/isin-report.ndjson ]; then
    ./points.js > output/isin-report.ndjson
fi

# This alternative method uses the ArangoDB 3.4+ geo-functions to see
# whether a point 'is in' the GeoJSON polygon/multipolygon
if [ ! -f output/isin-report.ndjson ]; then
    ARUSR=isin
    ARDBN=geodatabase

    PATH=${PATH}:./bin

    export ARUSR ARDBN

    . bin/ar-env.sh
    ./create-isindb.sh

    < isin.aql aqlx.sh > output/isin-report.ndjson
fi

if [ ! -f output/counties.ndjson ]; then
    < output/isin-report.ndjson ndjson-reduce '(p[d.county.name] = p[d.county.name] || []).push(d.location.name), p' '{}' | ndjson-split 'Object.keys(d).map(key => ({county: key, places: d[key]}))' > output/counties.ndjson
fi

if [ ! -f output/british-isles.ndjson ]; then
    < output/british-isles.json \
        jq -c '.features[]' >  output/british-isles.ndjson
fi

if [ ! -f output/british-isles-joined.ndjson ]; then
    ndjson-join 'd.id' 'd.county' output/british-isles.ndjson output/counties.ndjson | ndjson-map 'd[0].properties.places = d[1].places, d[0]' > output/british-isles-joined.ndjson
fi

if [ ! -f output/british-isles.geo.json ]; then
    < output/british-isles-joined.ndjson \
      jq -s -c '{type: "FeatureCollection", features: .}' > output/british-isles.geo.json
fi
