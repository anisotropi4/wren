#!/bin/sh

sort - | uniq -c | sort -rn | sed 's/^ *\([0-9][0-9]*\) \(.*\)$/\2\t\1/'
