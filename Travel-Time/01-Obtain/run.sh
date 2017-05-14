#!/bin/sh -x
#Station CRS code

if [ ! -f Rail-stations-travel-times.zip ]
then
    wget http://data.dft.gov.uk.s3.amazonaws.com/connectivity-data/Rail-stations-travel-times.zip
fi

# get Lower Layer Super Output Areas 2001 data
if [ ! -f 90e15daaaeef4baa877f4bffe01ebef0_2.zip ]
then    
    wget http://geoportal.statistics.gov.uk/datasets/90e15daaaeef4baa877f4bffe01ebef0_2.zip
fi

# get Lower Layer Super Output Areas 2001 data
if [ ! -f da831f80764346889837c72508f046fa_3.zip ]
then
    wget http://geoportal.statistics.gov.uk/datasets/da831f80764346889837c72508f046fa_3.zip
fi

sha512sum -c zip-checksum.sha512 
