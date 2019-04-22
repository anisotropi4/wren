#!/bin/sh

if [ ! -f osmconf.ini ]; then
    ln ../osmconf.ini
fi

for region in british-isles
do
    ELEMENT=multipolygons
    if [ ! -f output-01.json ]; then
	      ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
		            -where "admin_level = '6' AND (name IS NOT NULL)" \
		            -f GeoJSON \
		            output-01.json \
		            ../${region}-latest.osm.pbf \
		            ${ELEMENT}
    fi

    if [ ! -f output-02.json ]; then
	      ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
		            -where "(admin_level = '6' OR (ceremonial_county IS NOT NULL)) AND (name IS NOT NULL)" \
		            -f GeoJSON \
		            output-02.json \
                ../${region}-latest.osm.pbf \
		            ${ELEMENT}
    fi

    if [ ! -f output-03.json ]; then
	      ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
		            -where "(admin_level = '6' OR (ceremonial_county IS NOT NULL)) AND (boundary IS NOT NULL) AND (name IS NOT NULL)" \
		            -f GeoJSON \
		            output-03.json \
                ../${region}-latest.osm.pbf \
		            ${ELEMENT}
    fi

    if [ ! -f output-04.json ]; then
	      ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
		            -where "(admin_level = '6' OR (ceremonial_county IS NOT NULL)) AND (boundary IS NOT NULL) AND (boundary != 'traditional') AND (name IS NOT NULL)" \
		            -f GeoJSON \
		            output-04.json \
		            ../${region}-latest.osm.pbf \
		            ${ELEMENT}
    fi
done
