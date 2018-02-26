#!/bin/sh

echo 'DROP DB NaPTAN' | basex
echo 'CREATE DB NaPTAN Naptan.xml' | basex

< tree-dump.xq basex | sed '/^$/d' | tail -n +5 | sed 's/^\([ 0-9]*\) \(.*$\)/\2\t\1/' | head -n -2 > tree-dump.tsv

#echo "level-1	level-2	level-3	level-4	level-5	level-6	level-7	level-8	count" | tee level-8.tsv

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

mkdir output
for i in `tail -n +2 level-3.tsv | awk 'BEGIN { FS="	" } { print $3 }'`
do
    echo ${i}
    ./dump-xml.sh NaPTAN ${i}
done

for i in $(ls output/*.xml)
do
    echo ${i}
    FILE=$(basename ${i})
    XTAG=$(echo ${FILE} | sed 's/.xml//')
    < ${i} parallel -j 1 --files --pipe -N1024 add-x-tag.sh rmxmlns.sh | parallel -j 4 "xml-to-ndjson.sh {} ${XTAG}; rm {}" > output/${XTAG}.ndjson
done

