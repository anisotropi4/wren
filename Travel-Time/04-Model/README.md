# Model and iNterpret

  This is where the Train-Time and Lower Layer Super Output Areas geography datais visualised

  The 'run.sh' script flattens the rendered '.svg' files to .png' files in the images directory and then creates a framework 'index.html' using the 'html-script.sh'

### Flatten Scalar Vector Graphic (SVG) files to Portable Network Graphic (PNG) image file

  Using the 'svgexport' node.js application and the Imagemagick tool set 'convert' convert the SVG files from the 03-Explore directory to a 'png' file in the 'images' directory by running for the AM York file:

```
$ svgexport topo-YRK-01.svg topo-YRK-01.png.tmp
$ convert topo-YRK-01.png.tmp -background white -flatten images/topo-YRK-01.png
```
  Rather than an 'invisible' background this adds a white background to the PNG files 


### Create html 'index.html' file

   The 'html-script.sh' creates html that places thumbnail and links to the full image files in a grid based on location and time  

   The 'stations' files consists of a lookup table of CRS codes and stations names based on data from the National Rail Station Codes here 'http://www.nationalrail.co.uk/stations_destinations/48541.aspx'

### View data

   Running a local webserver and browsing the the corresponding localhost and port renders the data for the 183 stations. Running the following in the 'Model' directory creates a webserver on port 8080 for python2

```
python -m SimpleHTTPServer 8080
```

The equivalent python3 command is

```
python -m http.server 8080
```

### Create a video

   To create a short video 'output.mp4' of travel-time data from north to south using the 'ffmpeg' utility

   The 'link.py' script links the '.png' files in the 'images' directory to an order set in the 'output' directory based on a numbered list of stations in the 'stationorder' file arranged by latitude and longitude based

   Using a copy of the 'topo-ABD-PT_01.png' from the images directory add text to the start_0.png.template and create a link to 32 copies of this file in the 'output' directory

   Create the 'output.mp4' video using the following 'ffmpeg' with a 'glob *' pattern to order the constituent image file with a frame-rate six frames per second

```
$ ffmpeg -framerate 6 -pattern_type glob -i 'output/*.png' -c:v libx264 -pix_fmt yuv420p output.mp4
```