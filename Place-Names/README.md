# Mapping Place Names in the British Isles

Place names are often linked to geography or history. This looks at an interactive map of the British Isles based on Open Street Map data based on on the article *Mapping UK place name endings (With command line cartography tools)* [here](https://blog.scottlogic.com/2017/06/25/uk-place-names.html)

This an attempt to apply the OSEMN model as described [here](http://www.dataists.com/tag/osemn) and on the work of Jeroen Janssens in ['Data Science at the Command Line'](https://github.com/jeroenjanssens/data-science-at-the-command-line)

## Open Street Map (OSM)

The Open Street Map data visualised is used under the Open Street Map [license](https://www.openstreetmap.org/copyright). The data used for the analysis is from [GeoFabrik](http://www.geofabrik.de) using their download hosting service [here](http://download.geofabrik.de)

## Data Processing Toolset

The vector utility program 'ogr2ogr' is part of the Geospatial Data Abstraction Library (GDAL) toolset. On a Debian based system this is included in the 'gdal-bin' package and can be installed as follows:

    $ sudo apt install gdal-bin

The OSM 'osmupdate' tool is part of the 'osmctools' toolset. On a Debian based system this is included in the 'osmctools' package and can be installed as follows:

    $ sudo apt install osmctools

The 'jq' utility is a lightweight and flexible command-line JSON processor. On a Debian based system this is included in the 'jq' package and can be installed as follows:

    $ sudo apt install jq

The 'osmconfig.ini' is based on the file from ODI Leeds used under © Creative Commons BY 4.0 ODI Leeds 2018 https://creativecommons.org/licenses/by/4.0/

## Visualisation

The data is then visualised using a combination of the Leaflet.js (https://leafletjs.com/examples/geojson), and d3.js (https://d3js.org) javascript libraries



