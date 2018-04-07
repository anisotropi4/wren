#!/bin/sh

dump-tree.py Naptan.xml tree-dump.tsv

echo total
wc -l tree-dump.tsv 

echo level-1
< tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 }' | uniq -c | head -8
echo level-2
< tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 }' | uniq -c | head -8
echo level-3
< tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 "	" $3 }' | uniq -c | head -8
echo level-4
< tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 "	" $3 "	" $4 }' | uniq -c | head -8

mkdir output

xml-split.py --path output --depth 2 Naptan.xml

for i in output/*.xml
do
    echo ${i}
    FILE=$(basename ${i})
    XTAG=$(echo ${FILE} | sed 's/.xml//')
    < ${i} parallel -j 1 --files --pipe -N1024 add-x-tag.sh | parallel -j 4 "xml-to-ndjson.sh {}; rm {}" > output/${XTAG}.ndjson
done
