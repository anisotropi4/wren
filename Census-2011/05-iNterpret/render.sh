#!/bin/sh -x

for i in $@
do
    < setup/${i}.ndjson ndjson-map -r d3 '(d.properties.fill = d3.scaleSequential(d3.interpolateViridis).domain([0, 515])(d.properties.density_ha), d)' | geo2svg -n --stroke none -p 1 -w 960 -h 960 > output/${i}-colours.svg

    < setup/${i}.ndjson ndjson-map -r d3 '(d.properties.fill = d3.scaleSequential(d3.interpolateViridis).domain([0, 22.7])(d.properties.sqrt), d)' | geo2svg -n --stroke none -p 1 -w 960 -h 960 > output/${i}-sqrt-colours.svg 

    < setup/${i}.ndjson ndjson-map -r d3 '(d.properties.fill = d3.scaleSequential(d3.interpolateViridis).domain([6.5, -2.0])(d.properties.log), d)' | geo2svg -n --stroke none -p 1 -w 960 -h 960 > output/${i}-log-colours.svg
done

