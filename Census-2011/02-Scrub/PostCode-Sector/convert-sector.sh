#!/bin/sh  -x

i=$1
i=${i:-PostalSector}

ogr2ogr -t_srs EPSG:4326 -f GeoJSON ${i}.json ${i}.shp
