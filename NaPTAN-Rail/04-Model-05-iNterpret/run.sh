#!/bin/sh -x

# The count and reordering of fields can be found in the 'suniq.sh' script
# in the <https://github.com/anisotropi4/goldfinch> repository

echo "Type	Count" > StopTypes.tsv
< StopPoint.ndjson jq -c -r '.StopClassification.StopType' | sort - | uniq -c | sort -rn | sed 's/^ *\([0-9][0-9]*\) \(.*\)$/\2\t\1/' >> StopTypes.tsv

< StopPoint.ndjson jq -c '{AtcoCode} + (.Descriptor | {CommonName, Street, Indicator} ) + (.Place.Location.Translation | {lat: (.Latitude | (tonumber * 1E5) + 0.5 |  floor / 1E5), lon: (.Longitude | (tonumber * 1E5) + 0.5 |  floor / 1E5)}) + (.Place | {node: .NptgLocalityRef}) + (.StopClassification | {stoptype: .StopType}) | del(.[] | select(. == null))' > naptandata.ndjson

< naptandata.ndjson jq -c -s -r '.' > naptandata.json

