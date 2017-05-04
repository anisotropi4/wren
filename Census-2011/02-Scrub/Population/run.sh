#!/bin/sh

# England and Wales
cp ../../01-Obtain/england-and-wales_data.csv .
(cat header; < england-and-wales_data.csv sed -n '/^"[A-Z]....[0-9]",/p') | sed 's/,/\t/g' > england-and-wales_data.tsv

# Scotland
(cat header; xlsx2tsv.py scotland-islands.xlsx 2 | sed -n '/^\t[A-Z][A-Z0-9]..*\t/p' | sed 's/^\t//; s/\.0\t/\t/g') > scotland-islands.tsv
(cat header; xlsx2tsv.py scotland-mainland.xlsx 2 | sed -n '/^\t[A-Z][A-Z0-9]..*\t/p' | sed 's/^\t//; s/\.0\t/\t/g') > scotland-mainland.tsv

