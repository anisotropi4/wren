#!/bin/sh

for region in british-isles
do
    if [ ! -f ${region}-latest.osm.pbf ]; then
	      wget --no-clobber --quiet http://download.geofabrik.de/europe/${region}-latest.osm.pbf
    fi
    ./update.sh
fi
