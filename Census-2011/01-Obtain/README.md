The data used for the 2011 Census cloropleth visualisations consists of:

1) PostCode shapefile:  

  Download the ~280MB 'PostalBoundariesOpen2012.zip' PostCode Sector shapefiles for Great Britain (England, Scotland and Wales) from GeoLytix 'https://geolytix.net/?postal_geom'  

2a) Census data for England and Wales

Download census data for England and Wales via a webbrowser from 'nomis' here 'http://www.nomisweb.co.uk/query/select/getdatasetbytheme.asp?opt=3' then with the following options:  
  * The data was from 'Census 2011'
  * Under this 'Key Statistic/KS101EW - Usual resident population'
  * Under 'Geography' the option 'All' and 'postcode sectors' was selected
  * Under 'Variable' the options 'All usual residents' and all other options were selected
  * Under 'Get your data:' in 'Format / Layout' the 'Database - Tab separated values (.tsv) was selected
  * Under 'Download Data' the 'Data results (.csv)' file was downloaded

Rename this ~7MB data comma-seperated data file 'england-and-wales_data.csv'

2b) Census data for Scotland

Download census data for Scotland via a webbrowser from 'http://www.scotlandscensus.gov.uk/ods-web/standard-outputs.html' then with the following options  
  * The data was 'Census 2011'  
  * Under 'Select Table' select 'KS101SC - usual resident population'  
  * Under 'Select area type' select 'Local Characteristic Postcode Sector'  
  * Use the the 'lasso' tool on the graphical interface to select areas of interest  
  * This selection process will need to be repeated as there is an issue as the tool only allows the selection of 999 data  
     * First select all the areas on bulk of the main land excluding the Outer Hebrides, Orkney and Shetland islands  
     * Second select the Outer Hebrides, Orkney and Shetland islands  
  * Select 'View table' and download the table as 'table.xlsx'
  * Rename this as 'scotland-table-main.xlsx' repeat renaming the file as 'scoltand-table-islands.xlsx'

If there is an overlap this will be removed in the next 'Scrub' stage  
