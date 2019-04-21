#!/bin/sh

wget -nc -O naptan.zip http://naptan.app.dft.gov.uk/Datarequest/naptan.ashx

if [ ! -f Naptan.xml ]; then
    unzip naptan.zip
fi
