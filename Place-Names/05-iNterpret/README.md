# iNterpret

Using d3js libraries render the boundaries and the area fill density based on the number of times a place name in that area that contains a given phrase
 
## Visualisation

The British Isles is visualised using the `d3.geoConicEqualArea()` using the using the `d3.geoConicEqualArea()` [projection](https://github.com/d3/d3-geo/blob/master/README.md#geoConicEqualArea), converted to `GeoTOPO` format and rendered in a webbrowser using the `index.html`

Viewing a local web-server on port 8080 as below and browsing to the [index.html](localhost:8080/index.html) to view the map visualisation and chose a different phrase

```
    $ python -m http.server 8080&
```

The *county* boundary area also contains a list of *place names* within the boundary area. The fill density is calculated by calculating the percentage of *place names* that contain that phrase as a fraction of the total number of place names in a given *county* area

