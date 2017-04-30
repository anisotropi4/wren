#!/bin/sh
# process geography PostalSector 'json' files and output trial 

for i in $@
do
    if [ ! -f "run/${i}.ndjson" ]
    then
	< ${i}.json jq -c '.features[]' > run/${i}.ndjson
    fi

    if [ ! -f "run/${i}-id.ndjson" ]
    then
	< run/${i}.ndjson ndjson-map 'd.id = d.properties.RMSect, d' > run/${i}-id.ndjson
    fi

    if [ ! -f "run/${i}-topo.ndjson" ]
    then
	< run/${i}-id.ndjson geo2topo -n tracts=- | toposimplify -s 2.5E-10 -F | topo2geo -n tracts=- > run/${i}-topo.ndjson
    fi
    
    if [ ! -f "output/${i}-conic.ndjson" ]
    then
	< run/${i}-topo.ndjson jq -s -c '{"type": "FeatureCollection", "features": .}' | geoproject 'd3.geoConicEqualArea().parallels([49, 61]).rotate([0, 0, 0]).fitSize([960, 960], d)' | jq -c '.features[]' > output/${i}-conic.ndjson
    fi

    if [ ! -f "output/${i}-simple-conic.ndjson" ]
    then	
	< output/${i}-conic.ndjson geo2topo -n tracts=- | toposimplify -p 1 -f | topo2geo -n tracts=- > output/${i}-simple-conic.ndjson
    fi

    if [ ! -f "output/${i}-quantized-conic.ndjson" ]
    then	
	< output/${i}-simple-conic.ndjson geo2topo -n tracts=- | topoquantize 1E6 | topo2geo -n tracts=- > output/${i}-quantized-conic.ndjson
    fi
    
    geo2svg -n -w 960 -h 960 output/${i}-conic.ndjson > ${i}-conic.svg

    geo2svg -n -w 960 -h 960 output/${i}-simple-conic.ndjson > ${i}-simple-conic.svg

    geo2svg -n -w 960 -h 960 output/${i}-quantized-conic.ndjson > ${i}-quantized-conic.svg
done
