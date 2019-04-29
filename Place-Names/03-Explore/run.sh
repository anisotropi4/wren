#!/bin/sh

if [ ! -d output ]; then
    mkdir output
fi

if [ ! -f output/geo-multipolygons.json ]; then
    ln ../02-Scrub/output/geo-multipolygons.json output/geo-multipolygons.json
fi

if [ ! -f output/geo-multipolygons-simplified.ndjson ]; then    
    geo2topo counties=output/geo-multipolygons.json | \
        toposimplify -p 1E-5 -f | \
        topo2geo -n counties=- > output/geo-multipolygons-simplified.ndjson
fi

if [ ! -f output/british-isles.ndjson ]; then
    < output/geo-multipolygons-simplified.ndjson ndjson-map 'd.id = d.properties.name, d' > output/british-isles.ndjson
fi

if [ ! -f output/british-isles.geo.json ]; then
    < output/british-isles.ndjson \
      jq -s -c '{type: "FeatureCollection", features: .}' | \
        ./rewind.js > output/british-isles.geo.json
fi

