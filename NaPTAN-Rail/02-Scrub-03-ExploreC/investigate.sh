#!/bin/sh
xdump-tree.py Naptan.xml tree-dump.tsv --depth 4
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

echo "level-1	level-2	level-3	count" | tee level-3.tsv
< tree-dump.tsv awk 'BEGIN { FS="	" } { print $1 "	" $2 "	" $3 }' | uniq -c | sed 's/^\([ 0-9]*\) \(.*$\)/\2\t\1/' >> level-3.tsv

sed 's/>[ \t]*</>\n</g' Naptan.xml > Naptan-fix.xml

mkdir output
xml-split4.py Naptan-fix.xml --badxml --path output --depth 2

for i in $(ls output/*.xml)
do
    echo ${i}
    FILE=$(basename ${i})
    XTAG=$(echo ${FILE} | sed 's/.xml//')
    < ${i} parallel -j 1 --files --pipe -N1024 add-x-tag.sh | parallel -j 4 "xml-to-ndjson.sh {}; rm {}" > output/${XTAG}.ndjson
done

