# Model and iNterpret  

The content of the National Public Transport Access Nodes (NaPTAN) data is now is a new-line delimited json format from the previous steps. 

The `run.sh` script contains the elements used to explore the data which looks to extract geographic rail and other information from the NaPTAN dataset that is then visualised.

## Assumptions  

The Model and iNterpret activities assume

  * `jq` tool is installed (https://stedolan.github.io/jq/)

  * A copy of TSV (tab-separated variable) file 'tree-dump.tsv' '02-Scrub-03-Explore' directory

  * A copy of the new-line delimited JSON file 'StopPoint.ndjson' from the '02-Scrub-03-Explore/output' directory

## Model the Data Structure

### Look for elements associated with 'Rail'

The original xml tree-structure contains elements called 'Rail'

    $ fgrep -i Rail tree-dump.tsv | more
    NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	Entrance	7
    NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	Entrance	7
    NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	Entrance	7
    ...
    --More--

To look at the associate json elements try

    $ fgrep -i rail StopPoint.ndjson | head -1 | jq '.' | more
    {
      "AtcoCode": "0170SGB20753",
      "Status": "active",
      "RevisionNumber": "4",
      "ModificationDateTime": "2016-11-11T11:53:04",
      "AdministrativeAreaRef": "051",
      "CreationDateTime": "2018-01-09T15:56:48",
      "Descriptor": {
        "CommonName": "Railway Tavern",
        "Street": "Wotton Road",
        "Indicator": "E-bound"
      },
    ...
      "StopClassification": {
        "StopType": "BCT",
        "OnStreet": {
          "Bus": {
            "BusStopType": "MKD",
            "MarkedPoint": {
              "Bearing": {
                "Degrees": "90",
                "CompassPoint": "E"
              }
            },
            "TimingStatus": "OTH"
          }
        }
      },
      "Modification": "new",
      "NaptanCode": "sglmwjp"
    }

Looking at the StopClassification data this is a bus-stop opposite the "Railway Tavern". Narrowing the search for the "Rail" tag gives:

    {
      "AtcoCode": "0100BRSTLTM0",
      "Status": "active",
      "RevisionNumber": "1",
      "StopAreas": {
        "StopAreaRef": {
          "Status": "active",
          "RevisionNumber": "0",
          "value": "910GBRSTLTM",
          "ModificationDateTime": "2018-01-09T15:56:19",
          "CreationDateTime": "2018-01-09T15:56:19",
          "Modification": "new"
        }
      },
    ...
      "Descriptor": {
        "CommonName": "Bristol Temple Meads Rail Station",
        "Indicator": "Entrance"
      },
    ...
      "StopClassification": {
        "StopType": "RSE",
        "OffStreet": {
          "Rail": {
           "Entrance": {}
          }
        }
      },
      "Modification": "new"
    }

Comparing the two output shows that the "StopClassification.StopType" field has a type "BST" for a Bus-Stop and "RSE" for Railway Entrance. The next step is to xtract and count the "StopType" elements:

    $ echo "Type	Count" > StopTypes.tsv
    $ < StopPoint.ndjson jq -c -r '.StopClassification.StopType' | suniq.sh >> StopTypes.tsv
    $ wc -l StopTypes.tsv
    18 StopTypes.tsv
    $ more StopTypes.tsv
    Type	Count
    BCT	413331
    BCS	4931
    RSE	4533
    RLY	2667
    ...
    RPL	3

### Look at railway elements for visualisation

Selecting an element with a StopType "RLY"

    $ < StopPoint.ndjson jq -c 'select(.StopClassification.StopType == "RLY")' | head -1 | jq '.'

    {
      "AtcoCode": "9100ABDARE",
      ...
      "Descriptor": {
        "CommonName": "Aberdare Rail Station",
        "Street": "-"
      },
      "Place": {
        "Location": {
          "Translation": {
            "Latitude": "51.71505790608",
            "GridType": "UKOS",
            "Easting": "300400",
            "Northing": "202800",
            "Longitude": "-3.44308344608"
          }
        },
        "LocalityCentre": "1",
        "NptgLocalityRef": "E0054662"
      },
    ...
      "StopClassification": {
        "StopType": "RLY"
        ...
      }
    ...
    }

Extract longitude and latitude and key attributes such as "AtcoCode", "Common Name" into a ndjson file and convert to json:

    $ < StopPoint.ndjson jq -c '{AtcoCode} + (.Descriptor | {CommonName, Street, Indicator} ) + (.Place.Location.Translation | {lat: .Latitude, lon: .Longitude}) + (.Place | {node: .NptgLocalityRef}) + (.StopClassification | {stoptype: .StopType}) | del(.[] | select(. == null))' > naptandata.ndjson
    $ < naptandata.ndjson jq -s -r '.' > naptandata.json

### Visualise data

Running a local webserver and browsing the the corresponding localhost and po
rt renders the NaPTAN data. Running the following in the 'Model and iNterpret' directory creates a webserver on port 8080

    $ python -m SimpleHTTPServer 8080&

Browsing to "http://localhost:8080/" uses the "index.html" file to render the data in the form of an interactive map based on the OpenStreetMap Leaflet and d3 javascript frameworks. Clicking on circles provides a view of additional attributes
