# Visualisation

In this directory example multipolygon administrative area files are generated. The final `output-all.json` file contains the data used for the interactive visualisation, while the `multipolygons-output-<nn>.json` files give examples of output for the `ogr2ogr` query development

## View data

A combination the Open Street Map (Leaflet)[https://leafletjs.com/] and (d3js)[https://d3js.org/] javascript libraries is used to visualise the data using a local webserver

### Local webserver

   Running a local webserver and browsing the the corresponding localhost and port renders the data. Running the following in the 'visualisation' directory creates a webserver on port 8080 for python2

```
python -m SimpleHTTPServer 8080
```

The equivalent python3 command is

```
python -m http.server 8080
```

### How to change the dataset

   Using your editor of choice change line 48 in the `index.html` to view the first `output-01` dataset you should modify

```
     d3.json("output-all.json").then(function(d) {
             function onEachFeature(feature, layer) {
                    var this_feature = feature.properties;

```

To read

```
     d3.json("output-01.json").then(function(d) {
             function onEachFeature(feature, layer) {
                    var this_feature = feature.properties;
```

## Boundary Data Visualisation

Visualisation of boundary data in a web-browser is the fastest way to spot issues. The three example datasets can be created using the `example.sh` script.

Based on the previous work an Open Street Map (OSM) data the county or equivalent area would seem a reasonable area to aggregate data. This level is tagged in the OSM data and is tagged with an `admin_level` of 6. More information about adminstrative region tagging in OSM is [here](https://wiki.openstreetmap.org/wiki/Tag%3aboundary=administrative)

### First dataset `output-01.json`

In the first case the area around South Yorkshire is missing in the `output-01` dataset using the simple query:

```
    -where "admin_level = '6' AND (name IS NOT NULL)"
```

This is because `South Yorkshire` is a ceremonial country rather than an administrative area. However, `South Yorkshire` has `ceremonial_county` which will then be used

### Second dataset `output-02.json`

Having now included the ceremonial county of `South Yorkshire` as follows:

```
     -where "(admin_level = '6' OR (ceremonial_county IS NOT NULL)) AND (name IS NOT NULL)"
```

Based on colour density, a number areas in-and-around London are being doubled. Looking at the data, there are historical counties being added that without a `boundary` tag which will now be excluded.

### Third dataset `output-03.json`

Excluding all areas without named boundaries as follows appears to make no difference to the doubled up areas:

```
    -where "(admin_level = '6' OR (ceremonial_county IS NOT NULL)) AND (boundary IS NOT NULL) AND (name IS NOT NULL)"
```

Looking at the data again it would appear that there are counties where the `boundary` tag is marked as `traditional` which will be excluded


### Fourth dataset `output-04.json`

Visualisation of the following query would appear to produce a uniform set of areas covering the British Isles  

```
    -where "(admin_level = '6' OR (ceremonial_county IS NOT NULL)) AND (boundary IS NOT NULL) AND (boundary != 'traditional') AND (name IS NOT NULL)"

```

## Note on editor

The [emacs](https://www.gnu.org/software/emacs) editor was used during development.