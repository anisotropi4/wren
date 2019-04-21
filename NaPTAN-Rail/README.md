# National Public Transport Access Nodes (NaPTAN) Visualisation

This contains scripts that creates a dynamic geographic visualisation of NaPTAN data with a simple interface that allows the characteristics of points-of-interest to be displayed

This an attempt to apply the OSEMN model as described [here](http://www.dataists.com/tag/osemn) and on the work of Jeroen Janssens in 'Data Science at the Command Line' [here](https://github.com/jeroenjanssens/data-science-at-the-command-line)

The National Public Transport Access Nodes (NaPTAN) data is licensed under the Open Government License v3.0 [here](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/)

## Obtain  

Download the NaPTAN data from the [here](http://naptan.app.dft.gov.uk/Datarequest/naptan.ashx)

## Scrub and explore
 
Scripts to scrub and consolidate the NaPTAN stop data and convert from the "xml"to "ndjson" for visualist, look at how the location data is encoded, and the different stop types are identified through the **StopType** attribute  

## Model and iNterpret

Model, simplify and visualise the 430k+ transport node data using the d3.js and Open Street map javascript frameworks
