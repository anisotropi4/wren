# Scrub

  This is where the initial cut of Train-Time and Lower Layer Super Output Areas geography data.  

  The 'run.sh' script contains script  

### Assumptions

The Scrub activities assume 
  * The 'jq' utility. On a Debian based Linux version run:
  
  `$ sudo apt install jq`

  * The Node.js 'npm' utility. On a Debian based Linux version run:
  
  `$ sudo apt install npm`

  * The following 'd3' npm packages installed as root:

``` 
$ sudo npm install -g d3-geo-projection
$ sudo npm install -g d3-format
$ sudo npm install -g ndjson-cli
$ sudo npm install -g ndjson-cli
$ sudo npm install -g topojson
$ sudo npm install -g d3
$ sudo npm install -g d3-scale-chromatic
```

### Train-Time Data

  This creates the new-line delimited `Stations_<type>_<time>.ndjson` file. The data includes connection times for road, public transport and rail:

File name | Destination | Time of Day | Modal Type | Year 2011 | Rows |
----------|-------------|-------------|------------|-----------|---------|
Rail-stations-travel-times.zip 
Stations_HW_AM.csv | Rail stations | AM peak (7am to 10am) | Car | 2011 | 6,274,704
Stations_HW_Mid.csv | Rail stations | Mid peak (10am to 4pm) | Car | 2011 | 6,274,704
Stations_HW_PM.csv | Rail stations | PM peak (4pm to 7pm) |Car | 2011 | 6,274,704
Stations_PT_AM.csv | Rail stations | AM peak (7am to 10am) | Public transport | 2011 | 2,244,943
Stations_PT_Mid.csv |	Rail stations | Mid peak (10am to 4pm) | Public transport | 2011 | 3,733,339
Stations_PT_PM.csv |	Rail stations | PM peak (4pm to 7pm) | Public transport | 2011 | 3,646,483
Stations_PT_Late.csv |	Rail stations | Late (7pm to midnight) | Public transport | 2011 | 3,217,877

  As the train-time data is large, to avoid paging the data is split and runs the 'jq-script.sh'  

```
$ cat jq-script.sh
sed 's/"//g' | jq --slurp --raw-input --raw-output -c 'split("\n") | map(split(",")) | .[] | select(.[0] != null) | {CRS: .[3], (.[0]): .[1]}'
```

  For example, for the 'Stations_HW_AM.ndjson' new-line delimited json file is then blocks of 2**18 = 262144 lines  
```
$ tail -n +2 Stations_HW_AM.csv | \
        split -l 262144 --filter=./jq-script.sh | \
        sort | \
        split -l 8192 --filter="jq -c -s 'group_by(.CRS) | .[] | add'" | \
        jq -c -s 'group_by(.CRS) | .[] | add' > Stations_HW_AM.ndjson

```

### Lower Layer Super Output Areas geography data

  Create the 'LLSOA-2001-England-and-Wales.ndjson' new-line delimited Lower Layer Super Output Area geography data is in the shapefile Ordnance Survey OSGB36 format (EPSG:27700). Convert the 2001 to World Geodetic System WGS 84 format (EPSG:4326) using the ogr2ogr GDAL tool pipeline:

```
$ for i in *2001*.shp
  do
      ogr2ogr -t_srs EPSG:4326 -f GeoJSON /vsistdout/ ${i} | \
      jq -c '.features[] | ({ id: .properties.lsoa01cd} +  . )' | \
      geo2topo -n tracts=- | toposimplify -s 2.5E-10 -F | \
      topo2geo -n tracts=- 
  done > LLSOA-2001-England-and-Wales.ndjson
```
  The size of the data is then simplified combining features of less than about 1 Hectare (100m x 100m) using the 'toposimplify' node tool  

  The data is the used in the next stage to explore and combine the data  
