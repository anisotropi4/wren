#!/bin/sh

echo "Type	Count" > StopTypes.tsv
< StopPoint.ndjson jq -c -r '.StopClassification.StopType' | ./suniq.sh >> StopTypes.tsv

< StopPoint.ndjson jq -c '{AtcoCode} + (.Descriptor | {CommonName, Street, Indicator} ) + (.Place.Location.Translation | {lat: .Latitude, lon: .Longitude}) + (.Place | {node: .NptgLocalityRef}) + (.StopClassification | {stoptype: .StopType}) | del(.[] | select(. == null))' > naptandata.ndjson

< naptandata.ndjson jq -c -s -r '.' > naptandata.json

