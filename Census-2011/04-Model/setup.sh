#!/bin/sh
# Create initial files for visualisation
if [ ! -f "setup/PostalSector.ndjson" ]
then
    < PostalSector.json jq -c '.features[]' > setup/PostalSector.ndjson
    cp setup/PostalSector.ndjson run/
fi

if [ ! -f "setup/PostalSector-areas.ndjson" ]
then
    < run/PostalSector.ndjson ./areas.sh > setup/PostalSector-areas.ndjson
fi

< gb-census-report.tsv csvjson -t | jq -c 'sort_by(.id)' | jq -c '.[]' > setup/gb-census-report.ndjson

ndjson-join 'd.id' setup/PostalSector-areas.ndjson setup/gb-census-report.ndjson | ndjson-map '{id: d[0].id, area_m2: +d[0].area_m2, area_ha: +d[1].area_ha, area: Math.ceil((d[1].area_ha == 0) ? (d[0].area_m2 / 10000.0) : +d[1].area_ha), population: +d[1].population, density_ha: +d[1].population / ((d[1].area_ha == 0) ? Math.ceil(d[0].area_m2 / 10000.0) : d[1].area_ha), pdensity_ha: Math.max(1.0, +d[1].population) / ((d[1].area_ha == 0) ? Math.ceil(d[0].area_m2 / 10000.0) : d[1].area_ha)}' > output/gb-census-report-density.ndjson
