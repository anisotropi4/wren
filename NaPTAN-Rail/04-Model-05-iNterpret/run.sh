#!/bin/sh -x

export PATH=${PATH}:.
# The count and reordering of fields can be found in the 'unip' script
# in the <https://github.com/anisotropi4/goldfinch> repository

for i in StopPoint.ndjson StopArea.ndjson
do
    if [ ! -f ${i} ]; then
        ln ../02-Scrub-03-ExploreC/output/${i}
    fi
done

if [ ! -f StopTypes.tsv ]; then
    echo "Type	Count" > StopTypes.tsv
    < StopPoint.ndjson jq -c -r '.StopClassification.StopType' | unip -r >> StopTypes.tsv
fi

if [ ! -f national-codes.txt ]; then
    jq -r '.StopAreaCode[:3] // .AtcoCode[:3]' StopArea.ndjson StopPoint.ndjson | sort -u > national-codes.txt
fi

if [ ! -f naptandata.ndjson -o ! -f naptandata.json ]; then
    < StopPoint.ndjson jq -c '(if .AtcoCode[0:1] == "9" then {TIPLOC: .AtcoCode[4:]} else {} end) + {AtcoCode} + (.Descriptor | ({Name: .CommonName} + {Street, Indicator})) + (.Place.Location.Translation | {lat: (.Latitude | (tonumber * 1E5) + 0.5 |  floor / 1E5), lon: (.Longitude | (tonumber * 1E5) + 0.5 |  floor / 1E5)}) + (.Place | {node: .NptgLocalityRef}) + (.StopClassification | {stoptype: .StopType}) | del(.[] | select(. == null))' > naptandata.ndjson

    < StopArea.ndjson jq -c '(if .ParentStopAreaRef then {ParentStopAreaRef: .ParentStopAreaRef.value} else {} end) as $parent | (if .ParentStopAreaRef.value[0:1] == "9" then {ParentTIPLOC: .ParentStopAreaRef.value[4:]} else {} end) as $parenttiploc | (.Location.Translation | {lat: (.Latitude | (tonumber  * 1E5) + 0.5 | floor / 1E5), lon: (.Longitude | (tonumber * 1E5) + 0.5 | floor / 1E5)}) as $location | (if (.StopAreaCode[0:1] == "9") then {TIPLOC: .StopAreaCode[4:]} else {} end) as $TIPLOC | del(.Status, .RevisionNumber, .ModificationDateTime, .CreationDateTime, .Modification, .StopAreaType, .ParentStopAreaRef, .Location) as $output | $TIPLOC + $output + $location + $parent + $parenttiploc' >> naptandata.ndjson
    
    < naptandata.ndjson jq -rc 'select(.TIPLOC)'| jq -sc '.' > naptandata.json
fi
