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
