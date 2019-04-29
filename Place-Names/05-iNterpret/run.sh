#!/bin/sh

if [ ! -d output ]; then
    mkdir output
fi

if [ ! -f output/british-isles.geo.json ]; then
    ln ../04-Model/output/british-isles.geo.json output/british-isles.geo.json
fi
    
if [ ! -f output/british-isles-projected.geo.json ]; then
    < output/british-isles.geo.json \
      geoproject 'd3.geoAlbers().center([0, 54.4]).rotate([5, 0]).scale(1200 * 3).translate([1048 / 2, 660 / 2])' \
      > output/british-isles-projected.geo.json
fi

if [ ! -f british-isles.topo.json ]; then
    geo2topo counties=output/british-isles-projected.geo.json \
             > british-isles.topo.json
fi
