#!/bin/sh
# set up the data in the 'setup' directory

for i in $@
do
    ndjson-join 'd.id' gb-census-report-density.ndjson ${i}.ndjson | ndjson-map '{type: d[1].type, id: d[0].id, geometry: d[1].geometry, properties: {density_ha: d[0].density_ha, sqrt: Math.sqrt(d[0].density_ha), log: Math.log(d[0].pdensity_ha)}}' > setup/${i}-density.ndjson
    echo ${i} "\tmin\tmax"
    jq -c '.properties.density_ha' setup/${i}-density.ndjson | jq -c -s '. | ([min, max])' | sed 's/\]//g; s/\[/density_ha\t/g; s/,/\t/g'
    jq -c '.properties.sqrt' setup/${i}-density.ndjson | jq -c -s '. | ([min, max])' | sed 's/\]//g; s/\[/sqrt density_ha\t/g; s/,/\t/g'
    jq -c '.properties.log' setup/${i}-density.ndjson | jq -c -s '. | ([min, max])' | sed 's/\]//g; s/\[/log density_ha\t/g; s/,/\t/g'
done | tee parameters.tsv
