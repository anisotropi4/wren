# Scrub

This is where the initial cut of the Great Britain geography GeoJSON and population files are created  
 
## Assumptions  
The Scrub activities assume  
   * The 'ogr2ogr' utility is installed. On a Debian based Linux version run:  
  `$ sudo apt install gdal-bin`  

  * A SQL database is available to combine and scrub the Population data  

  * Information about installing and creating a PostgreSQL database Docker image can be found here 'https://github.com/guidoeco/docker' and the 'create_table.py' script here 'https://gist.github.com/anisotropi4/7c62a5961e22765800383fd0f2cc2fdd'
  
#### Create the 'PostalSector.json' file  

Create the 'PostalSector.json' file and transforms this from Ordnance Survey (OS 1936/ESPG:27700) to standard World Geodetic System (WGS 84/EPSG:4326) coordinates    
 
```
$ cd PostalCode-Sector
$ unzip ../../01-Obtain/PostalBoundariesOpen2012.zip
$ unzip PostalBoundariesSHP.zip
```

#### Create the 'PostalSector.json' GeoJSON file for the visualisation  
The PostalSector shapefile data is in OSGB 1936 (Ordnance Survey) format. Convert this to WG84 (EPSG:4326) GeoJSON  
```
$ ogr2ogr -t_srs EPSG:4326 -f GeoJSON PostalSector.json PostalSector.shp  
$ mv PostalSector.json ..  
```

These command are contained in the script 'convert-sector.sh'

## Extract the population data  

Extract the English, Welsh and Scottish population and area data to 'tsv' files with a consistent header of:  
  * PostCode Sector  
  * All people  
  * Males  	
  * Females  
  * In household  
  * In communal establishment  
  * Child or Student non term-time address  
  * Area [ha]  
  * Density [person/ha]  

#### Convert the England and Wales data to the tab-separated variable 'tsv' file format  

Convert the England and Wales from a comma-separated 'csv' tab-separated variable 'tsv' file format and add the file 'header'  

```
$ cd PostCode-Sector
$ cp ../../01-Obtain/england-and-wales_data.csv .
$ cp header england-and-wales_data.tsv
$ < england-and-wales_data.csv | england-and-wales_data.csv sed -n '/^"[A-Z]....[0-9]",/p' | sed 's/,/\t/g' > england-and-wales_data.tsv
```

Alternatively edit the file to remove extraneous columns and rows and set the correct header from the 'header' file

#### Extract the data from the Scotish 'xslx' reports to the tab-separated variable 'tsv' file format  

Flatten the 'xlsx' files and then edit the file to remove extraneous columns and rows and set the correct header

I use the 'xlsx2tsv' script on gist (https://gist.github.com/22764)

```
$ cp ../../01-Obtain/scotland-*.xlsx .
$ cp header scotland-islands.tsv
$ cp header scotland-mainland.tsv
$ xlsx2tsv.py scotland-islands.xlsx 2 | sed -n '/^\t[A-Z][A-Z0-9]..*\t/p' | sed 's/^\t//' >> scotland-islands.tsv
$ xlsx2tsv.py scotland-mainland.xlsx 2 | sed -n '/^\t[A-Z][A-Z0-9]..*\t/p' | sed 's/^\t//' >> scotland-mainland.tsv
```

Alternatively edit the file by hand using a standard spreadsheet tool e.g. libreoffice and save in the 'tsv' file format 

The combined England, Scotland and Wales file creation is contained in the 'run.sh' script  

## Combine and scrub the England and Wales, and Scottish Population data  

Combine the census data to create a combined 'gb-census-report-01.tsv' tab-separated census report using a 'PostgreSQL' database

This assumes:  
  * A PostgreSQL database running on the host 'pg-server' with a 'raven' user 
  * The 'create_table.py' python script 
  * The 'PostgreSQL' client tools installed

Details about how to set up a PostgreSQL database using 'docker' containers can be found here under the 'postgres' directory of 'https://github.com/guidoeco/docker'  

The 'create_table.py' script is a gist here 'https://gist.github.com/anisotropi4' or as part of the 'goldfinch' 'bin' scripts here 'https://github.com/anisotropi4/goldfinch'  

#### Create and run psql scripts to load population data in a PostgreSQL database

Create the table sql scripts:  

```
$ for i in *.tsv
$ do  
$ create_table.py ${i}.tsv  
$ done
```

Load the data into the PostgreSQL server 'pg-server' username 'raven':  
  
```
$ for i in table_*.sql
$ do  
$ < ${i} psql -U raven -h pg-server  
$ done
```

#### Generate the combined census report  

  Generate the combined census report 'gb-census-report-01.tsv'and  move the file into the '02-Scrub' directory:  

```
$ < census-report.sql psql -U raven -h pg-server  
$ mv gb-census-report-01.tsv ..
```

The database creation and reporting commands are contained in the 'create-database.sh' script

In the next stage 'Explore' is to link the geography and population report data  
