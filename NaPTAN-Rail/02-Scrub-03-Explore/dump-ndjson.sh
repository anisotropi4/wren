#!/bin/sh
TAG=$1
FILE=$2
FILE=${FILE:-$TAG}
< output/${FILE}.xml parallel -j 1 --files --pipe -N1024 add-x-tag.sh rmxmlns.sh | parallel -j 4 xml-to-ndjson.sh {} ${TAG} > output/${FILE}.ndjson

