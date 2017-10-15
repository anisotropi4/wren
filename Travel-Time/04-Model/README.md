# Model and iNterpret

  This is where the Train-Time and Lower Layer Super Output Areas geography datais visualised

  The 'run.sh' script flattens the rendered '.svg' files to .png' files in the images directory and then creates a framework 'index.html' using the 'html-script.sh'

### Flatten Scalar Vector Graphic (SVG) files to Portable Network Graphic (PNG) image file

  Using the Imagemagick tool set convert the SVG files from the 03-Explore directory to a 'png' file in the 'images' directory by running for the AM York file:

```
convert topo-YRK-01.svg -background white -flatten images/topo-YRK-01.png
```
  Rather than an invisible background this creates a white background to the PNG files 


### Create html 'index.html' file

   The 'html-script.sh' creates html that places thumbnail and links to the full image files in a grid based on location and time  

   The 'stations' files consists of a lookup table of CRS codes and stations names based on data from the National Rail Station Codes here 'http://www.nationalrail.co.uk/stations_destinations/48541.aspx'

### View data

   Running a local webserver and browsing the the corresponding localhost and port renders the data for the 183 stations. Running the following in the 'Model' directory creates a webserver on port 8080

```
python -m SimpleHTTPServer 8080
```