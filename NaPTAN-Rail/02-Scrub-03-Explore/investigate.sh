#!/bin/sh

echo 'DROP DB NaPTAN' | basex
echo 'CREATE DB NaPTAN Naptan.xml' | basex

< tree-dump.xq basex | sed '/^$/d' | tail -n +5 | sed 's/^\([ 0-9]*\) \(.*$\)/\2\t\1/' | head -n -2 > tree-dump.tsv

#echo "level-1	level-2	level-3	level-4	level-5	level-6	level-7	level-8	count" | tee level-8.tsv
echo "level-1	level-2	level-3	count" | tee level-3.tsv
< tree-dump.tsv awk 'BEGIN { FS="	" } { print $1 "	" $2 "	" $3 }' | uniq -c | sed 's/^\([ 0-9]*\) \(.*$\)/\2\t\1/' >> level-3.tsv

mkdir output
for i in `tail -n +2 level-3.tsv | awk 'BEGIN { FS="	" } { print $3 }'`
do
    echo ${i}
    ./dump-xml.sh NaPTAN ${i}
    ./dump-ndjson.sh ${i}
done
