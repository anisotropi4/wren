# Mapping Place Names in the British Isles

Place names are often linked to geography or history. This looks at an interactive map of the British Isles based on Open Street Map data based on on the article *Mapping UK place name endings (With command line cartography tools)* [here](https://blog.scottlogic.com/2017/06/25/uk-place-names.html)

This an attempt to apply the OSEMN model as described [here](http://www.dataists.com/tag/osemn) and on the work of Jeroen Janssens in ['Data Science at the Command Line'](https://github.com/jeroenjanssens/data-science-at-the-command-line)

## Open Street Map (OSM)

The Open Street Map data visualised is used under the Open Street Map [license](https://www.openstreetmap.org/copyright). The data used for the analysis is from [GeoFabrik](http://www.geofabrik.de) using their download hosting service [here](http://download.geofabrik.de)

## Data Processing Toolset

The vector utility program [ogr2ogr](https://www.gdal.org/ogr2ogr.html) is part of the Geospatial Data Abstraction Library (GDAL) toolset. On a Debian based system this is included in the 'gdal-bin' package and can be installed as follows:

    $ sudo apt install gdal-bin

The `osmconfig.ini` is based on the file from ODI Leeds used under [© Creative Commons BY 4.0](https://creativecommons.org/licenses/by/4.0/)

The OSM `osmupdate` tool is part of the [osmctools](https://gitlab.com/osm-c-tools/osmctools) toolset. On a Debian based system this is included in the 'osmctools' package and can be installed as follows:

    $ sudo apt install osmctools

The [jq](https://stedolan.github.io/jq/) utility is a lightweight and flexible command-line JSON processor. On a Debian based system this is included in the `jq` package and can be installed as follows:

    $ sudo apt install jq

The [nodejs](https://nodejs.org/en/) JavaScript runtime environment command line that allows local execution of JavaScript. Due to issues with package versions it is recommended the latest Long Term Supported version of nodejs is used. Details of maintained supported distributions is [here](https://github.com/nodesource/distributions/blob/master/README.md). Alternative details on installation of the package manager is [here](https://nodejs.org/en/download/package-manager/)

The [ndjson-cli](https://github.com/mbostock/ndjson-cli) command line tools that allow processing of [Newline Delimited JSON](http://ndjson.org/) streams on the command line. To install a local version of the `nodejs` libraries

    $ npm install ndjson-cli

The [d3](https://d3js.org/) nodejs package enables visualisation of data using web standards. To install a local version of the `nodejs` libraries

    $ npm install d3

### Notes

On a Unix, Linux or similar system the nodejs command line tools are installed in the local `~/node_modules/.bin` directory. These need to be referenced in the executable path (also know as shell PATH) variable for the command line tools to work

## Visualisation

The data is then visualised in the browser using the [d3js](https://d3js.org) javascript libraries

## Acknowledgements

This visualisation is based on the work of Colin Eberhardt in his article *
Mapping UK place name endings (With command line cartography tools)* [here](https://blog.scottlogic.com/2017/06/25/uk-place-names.html)
