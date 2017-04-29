# Scrub

This is where the initial cut of the Great Britain geography GeoJSON and population files are created  
 
## Assumuptions  
The Scrub activities assume  
   * The 'ogr2ogr' utility is installed. On a Debian based Linux version run:  
  `$ sudo apt install gdal-bin`  

  * A SQL database is available to combine and scrub the Population data  

  * Information about installing and creating a PostgreSQL database Docker image can be found here 'https://github.com/guidoeco/docker' and the 'create_table.py' script here 'https://gist.github.com/anisotropi4/7c62a5961e22765800383fd0f2cc2fdd'
  
#### Create the 'PostalSector.json' file  

Create the 'PostalSector.json' file and transforms this from Ordnance Survey (OS 1936/ESPG:27700) to standard World Geodetic System (WGS 84/EPSG:4326) coordinates    
 
 `$ cd PostalCode-Sector  
  $ unzip ../../01-Obtain/PostalBoundariesOpen2012.zip  
  $ unzip PostalBoundariesSHP.zip`  

#### Create the 'PostSector.json' GeoJSON file for the visualisation  
  `$ ogr2ogr -t_srs EPSG:4326 -f GeoJSON PostalBoundaries.json PostalBoundaries.shp
   $ mv PostalSector.json ..  
   $ cd ..`  

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

Convert the England and Wales from a comma-separated 'csv' tab-separated variable 'tsv' file format  

  `$ < england-and-wales_data.csv sed 's/,/\t/g' > england-and-wales_data.tsv`

Them edit the file to remove extraneous columns and rows and set the correct header

#### Extract the data from the Scotish 'xslx' reports to the tab-separated variable 'tsv' file format  

I use the 'xlsx2tsv' script by breandano on gist https://gist.github.com/22764

 `$ xlsx2tsv.py scotland-islands.xlsx 2 > scotland-islands.tsv
  $ xlsx2tsv.py scotland-mainland.xlsx 2 > scotland-mainland.tsv`  

Them edit the file to remove extraneous columns and rows and set the correct header

Alternatively edit the file by hand using a standard spreadsheet tool e.g. libreoffice and save in the 'tsv' file format

#### Combine and scrub the England and Wales, and Scottish Population data  

Create a combined 'gb-census-report-01.tsv' tab-separated census report

#### Create and run psql scripts to load population data in a PostgreSQL database

Create the table sql scripts:  

  `$ for i in *.tsv
   $ do  
   $ create_table.py ${i}.tsv  
   $ done`  

Load the data into the PostgreSQL server 'pg-server' username 'raven':  
  
  `$ for i in table_*.sql
   $ do  
   $ < ${i} psql -U raven -h pg-server  
   $ done`  

#### Generate the combined census report 'gb-census-report-01.tsv'  

  `$ < census-report.sql psql -U raven -h pg-server`  

Move the file into the '02-Scrub' directory:

   `$ mv gb-census-report-01.tsv ..  
    $ cd ..`  

In the next stage 'Explore' is to link the geography and population report data  
