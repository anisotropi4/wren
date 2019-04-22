#!/bin/sh

if [ ! -f british-isles.poly ]; then
    echo "update polygon file missing: british-isles.poly"
    exit 1;
fi

if [ ! -d archive ]; then
    mkdir archive
fi

osmupdate british-isles-latest.osm.pbf british-isles-update.osm.pbf -B=british-isles.poly --verbose --keep-tempfiles 

mv british-isles-latest.osm.pbf archive
mv british-isles-update.osm.pbf british-isles-latest.osm.pbf
