#!/bin/sh -x

if [ ! -d output ]; then
    mkdir output
fi

if [ ! -f osmconf.ini ]; then
    echo 'missing configuration file: osmconf.ini'
    exit 1
fi

for region in british-isles
do
    if [ ! -f ${region}-latest.osm.pbf ]; then
        ln ../01-Obtain/${region}-latest.osm.pbf
    fi

    ELEMENT=points
    if [ ! -f output/geo-${ELEMENT}.json ]; then
	      ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
                -where "name IS NOT null AND ((railway = 'station') OR place IN ('city', 'farm', 'hamlet', 'harbour', 'hill', 'island', 'moor', 'parish', 'pier', 'residence', 'square', 'suburb', 'town', 'valley', 'village', 'wood'))" \
		            -f GeoJSON \
		            output/geo-${ELEMENT}.json \
		            ${region}-latest.osm.pbf \
		            ${ELEMENT}
    fi

    ELEMENT=multipolygons
    if [ ! -f output/geo-${ELEMENT}.json ]; then
	      ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
		            -where "((CAST(admin_level AS INTEGER(1)) = 6) OR (ceremonial_county IS NOT NULL)) AND (boundary IS NOT NULL) AND (boundary != 'traditional') AND (name IS NOT NULL)" \
		            -f GeoJSON \
		            output/geo-${ELEMENT}.json \
		            ${region}-latest.osm.pbf \
		            ${ELEMENT}
    fi

    for i in points multipolygons
    do
        if [ ! -f output/geo-${i}.ndjson ]; then
            jq -c '.features[]' output/geo-${i}.json > output/geo-${i}.ndjson
        fi
    done
done

if [ ! -f visualisation/output-all.json ]; then
    ln output/geo-multipolygons.json visualisation/output-all.json
fi
