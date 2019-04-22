# Scrub

This is where the initial cut of the Great Britain geography GeoJSON multipolygon and point files are created  
 
## Assumptions  
The Scrub activities assume  
   * The 'ogr2ogr' utility is installed. On a Debian based Linux version run:  
  `$ sudo apt install gdal-bin`  

## Create the points of interest names files

  As the analysis on place-names, the names of points-of-interest in the OSM dataset in the 'points' layer are extracted and saved into the GeoJSON format file `geo-points.json` in the `output` directory

The arbitrary selection criteria are around whether a point has an associated name and that it is either tagged as a railway station or a place such as a city, farm, hamlet, harbour, hill, island, moor, parish, pier, residence, square, suburb, town, valley, village or wood using the following `ogr2ogr` query:

    $ ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
                -where "name IS NOT null AND ((railway = 'station') OR place IN ('city', 'farm', 'hamlet', 'harbour', 'hill', 'island', 'moor', 'parish', 'pier', 'residence', 'square', 'suburb', 'town', 'valley', 'village', 'wood'))" \
		            -f GeoJSON \
		            output/geo-points.json \
		            british-isles-latest.osm.pbf \
		            points

   The `osmconf.ini` file allows values for `name`, `railway` and `place` keys to be queried

   The `GeoJSON` format file is then converted to new-line delimited JSON (ndjson) using the `jq` tool for further processing:

    for i in points multipolygons
        jq -c '.features[]' output/geo-${i}.json > output/geo-${i}.ndjson
    done

## Create the administration area files

  As the analysis on place-names is aggregated as the county or similar level, the boundaries for these administrative areas from the OSM 'multipolygons' layer are extracted and saved into the GeoJSON format file `geo-multipolygons.json` in the `output` directory

	  $ ogr2ogr --config OSM_CONFIG_FILE osmconf.ini \
		        -where "((CAST(admin_level AS INTEGER(1)) = 6) OR (ceremonial_county IS NOT NULL)) AND (boundary IS NOT NULL) AND (boundary != 'traditional') AND (name IS NOT NULL)" \
		        -f GeoJSON \
		        output/geo-multipolygons.json \
		        british-isles-latest.osm.pbf \
            multipolygons


  The initial extract 