#!/bin/sh

export PATH=${PATH}:.

if [ ! -f Naptan.xml ]; then
    ln ../01-Obtain/Naptan.xml
fi

if [ ! -f Naptan-fix.xml ]; then
    sed 's/>[ \t]*</>\n</g' Naptan.xml > Naptan-fix.xml
fi

if [ ! -d output ]; then
    mkdir output
fi

if [ \( ! -f output/StopPoint.xml \) -o \( ! -f output/StopArea.xml \) ]; then
    xml-split4.py Naptan-fix.xml --badxml --path output --depth 2
fi

if [ \( ! -f output/StopPoint.ndjson \) -o \( ! -f output/StopArea.ndjson \) ]; then
    for i in $(ls output/*.xml)
    do
        echo ${i}
        FILE=$(basename ${i})
        XTAG=$(echo ${FILE} | sed 's/.xml//')
        < ${i} parallel -j 1 --files --pipe -N1024 add-x-tag.sh | parallel -j 4 "xml-to-ndjson.sh {}; rm {}" > output/${XTAG}.ndjson
    done
fi

