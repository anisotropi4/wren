#!/bin/sh

for i in `echo scotland*.tsv england*.tsv | sed 's/.tsv//g'`
do
  create_table.py ${i}.tsv
done

for i in table_*.sql
do
   < ${i} psql -U raven -h pg-server
done

< census-report.sql psql -U raven -h pg-server
