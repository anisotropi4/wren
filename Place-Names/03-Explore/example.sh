#!/bin/sh


if [ ! -d output ]; then
    mkdir output
fi

if [ ! -f output/geo-multipolygons.json ]; then
    ln ../02-Scrub/output/geo-multipolygons.json output/geo-multipolygons.json
fi

if [ ! -d visualisation ]; then
    mkdir visualisation
fi

if [ ! -f visualisation/british-isles.geo.json ]; then
    geo2topo counties=output/geo-multipolygons.json | \
        toposimplify -p 1E-5 -f | \
        topo2geo counties=- > visualisation/geo-simplified.json
fi

if [ ! -f visualisation/geo-rewind.json ]; then
    < visualisation/geo-simplified.json ./rewind.js > visualisation/geo-rewind.json
fi
