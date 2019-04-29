#!/bin/sh
# Set database name and user
ARUSR=isin
ARDBN=geodatabase

PATH=${PATH}:./bin

export ARUSR ARDBN
. bin/ar-env.sh

sh bin/createdb.sh

for i in points multipolygons
do
    < output/geo-${i}.ndjson arangoimp --file - --type jsonl --batch-size 134217728 --progress true --server.username ${ARUSR} --server.authentication true --server.database ${ARDBN} --server.endpoint "tcp://"${ARSVR}":8529" --server.password "${ARPWD}" --collection ${i} --create-collection true --overwrite true
    bin/creategeojsonindex.sh ${i}
done
