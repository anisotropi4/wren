#!/bin/sh -x
# Train travel-time data

if [ ! -f Stations_HW_AM.csv ]
then
   unzip Rail-stations-travel-times.zip Stations_HW_AM.csv
fi

if [ ! -f Stations_HW_AM.ndjson ]
then
    tail -n +2 Stations_HW_AM.csv | \
        split -l 262144 --filter=./jq-script.sh | \
        sort | \
        split -l 8192 --filter="jq -c -s 'group_by(.CRS) | .[] | add'" | \
        jq -c -s 'group_by(.CRS) | .[] | add' > Stations_HW_AM.ndjson
fi

if [ ! -s LLSOA-2001-England-and-Wales.ndjson ]
then
    unzip 90e15daaaeef4baa877f4bffe01ebef0_2.zip
    for i in *2001*.shp
    do
        ogr2ogr -t_srs EPSG:4326 -f GeoJSON /vsistdout/ ${i} | \
            jq -c '.features[] | ({ id: .properties.lsoa01cd} +  . )' | \
            geo2topo -n tracts=- | toposimplify -s 2.5E-10 -F | \
            topo2geo -n tracts=- 
    done > LLSOA-2001-England-and-Wales.ndjson
fi
