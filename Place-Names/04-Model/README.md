# Model  

In the Model section the point and area data is combined and aggregated to see whether a point 'is in' a given polygon and the boundary and point data combined

## Determining Whether a Point 'is in' a 'Area'

Having resolved issues with boundaries to allow the correct determiniation of wheter a point is inside or out a given boundary, the two approaches are suggested to report on whether points are within a given area

### Use of ArangoDB 3.4+ Geo Functions

Importing the points and multipolygon data into an ArangoDB [database](https://www.arangodb.com/) and run an `aql` script to interate though the boundaries allows a report to be created containg the points within a given areas to be determined using the [GEO_CONTAINS](https://docs.arangodb.com/3.4/AQL/Functions/Geo.html#geocontains) function. `GeoJSON` indexes are created on the data to speed the execution of the report

The set-up of an ArangoDB instance on using [Docker](https://www.docker.com/) containers, is given [here](https://github.com/guidoeco/docker)

### Use of d3js

The `points.js` [nodejs](https://nodejs.org/en/) script uses the [d3js](https://d3js.org/) to interate though boundaries to allows a report to be created containg the points within a given areas to be determined using the [d3.geoContains()](https://github.com/d3/d3-geo#geoContains) function

The bounding box for each boundary is calculated using the `d3.geoPath().projection(null)` function and this is then used through the [d3.quadtree()](https://github.com/d3/d3-quadtree) function to speed the execution of the report

## Data Combination

The *is in* report data is agregated by *county*, and the boundary and *is in* data is combined using the associated the `id` and `county` tags using the d3js [ndjson-cli](https://github.com/mbostock/ndjson-cli/blob/master/README.md) toolset. This New-line Delimited JSON *ndjson* data is then converted to GeoJSON