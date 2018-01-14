#!/bin/bash -x

DB=$1
XPATH=$2

echo | basex -sindent=no -o output/${XPATH}.xml <<EOF 
check ${DB}
xquery //*:${XPATH}
quit

EOF
