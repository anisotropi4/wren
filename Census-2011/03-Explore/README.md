# Explore
In the Explore section 

## Assumptions
The Explore activities assume
  * `jq` tool is installed (https://stedolan.github.io/jq/)
  * A spreadsheet program such as 'libreoffice' or 'gnucalc'
  * A copy of the 'PostalSector.json' and 'gb-census-report-01.tsv' is in the '03-Explore' directory

## Identify key

Look for a link between the geography and census data using shell tools e.g. 'more', 'jq' and 'libreoffice'  

### PostalSector geography data  

First look at the PostalSector geography data. The structure of the 'PostalSectors.json' consists of  
  * The 'FeatureCollection' header  
  * The 'features' array  
  * Each 'feature' then consists of a 'type', 'properties' and 'geometry'  

Using the 'jq' dump the 'properties'
```
$ < PostalSector.json jq -c '.features[].properties' > sector-properties.ndjson
$ more properties.ndjson
{"SectID":1,"RMSect":"AB10 1","GISSect":"AB10 1","StrSect":"AB101","PostDist":"A
B10","PostArea":"AB","DistNum":"10","SecNum":1,"PCCnt":266,"AnomCnt":0,"RefPC":"
AB101TH","x":393574,"y":806073,"Sprawl":"Aberdeen","Locale":null}
{"SectID":2,"RMSect":"AB10 6","GISSect":"AB10 6","StrSect":"AB106","PostDist":"A
B10","PostArea":"AB","DistNum":"10","SecNum":6,"PCCnt":243,"AnomCnt":3,"RefPC":"
AB106PS","x":392796,"y":805097,"Sprawl":"Aberdeen","Locale":null}
{"SectID":3,"RMSect":"AB10 7","GISSect":"AB10 7","StrSect":"AB107","PostDist":"A
B10","PostArea":"AB","DistNum":"10","SecNum":7,"PCCnt":216,"AnomCnt":0,"RefPC":"
AB107DS","x":392056,"y":803758,"Sprawl":"Aberdeen","Locale":null}
{"SectID":4,"RMSect":"AB11 5","GISSect":"AB11 5","StrSect":"AB115","PostDist":"A
B11","PostArea":"AB","DistNum":"11","SecNum":5,"PCCnt":139,"AnomCnt":1,"RefPC":"
AB115PW","x":394641,"y":805995,"Sprawl":"Aberdeen","Locale":null}
```

### Census population data  

Using libreoffice calc

```
$ more gb-census-report-01.tsv 

postcode_sector	population	males	females	household	communal_establi
shment	child	area_ha
AB10 1	2284	1184	1100	2280	4	13	73
AB10 6	10737	5446	5291	10594	143	88	166
AB10 7	8987	4322	4665	8800	187	46	224
AB11 5	1855	1005	850	1854	1	15	123
AB11 6	6424	3490	2934	6149	275	27	74
AB11 7	2616	1345	1271	2590	26	32	61
AB11 8	6821	3366	3455	6589	232	17	111

```

### The ID element  

  The obvious link is between the **RMSect** element in the properties.ndjson and the **postcode_sector** column in the 'gb-census-report-01.tsv'  

  The sector data
```
$ jq -r '.RMSect' sector-properties.ndjson | sort -u > sector-id.tsv
$ more sector-id.tsv
AB10 1
AB10 6
AB10 7
AB11 5
AB11 6
AB11 7
AB11 8
AB11 9
AB12 3
$ wc -l sector-id.tsv
9232 sector-id.tsv
```  
  Then the census data  
$ cut -f 1 gb-census-report-01.tsv  | tail -n +2 | sort -u > census-id.tsv
$ more census-id.tsv
AB10 1
AB10 6
AB10 7
AB11 5
AB11 6
AB11 7
AB11 8
AB11 9
AB12 3 (part) Aberdeen City
AB12 3 (part) Aberdeenshire
$ wc -l census-id.tsv
9045 census-id.tsv
```  

