# Scrub and Explore  

As the content of the National Public Transport Access Nodes (NaPTAN) rail visualisation appears to be clean, the Scrub and Explore stages are combined.

The `investigate.sh` script contains the elements used to explore the data which looks to extract geographic rail information from the NaPTAN dataset for visualisation.

This in alternative uses the `xml.etree.cElementTree` python library rather than `BaseX` XML Database engine

## Assumptions  

The Explore activities assume

  * `jq` tool is installed (https://stedolan.github.io/jq/)

  * `parallel` tool is installed

    $ sudo apt install parallel

  * A copy of the 'Naptan.xml' data is in the '01-Obtain' directory

## Load the Data and look at the Data Structure

### Dump field information

Running the `dump-tree.py` script against the NaPTAN data dumps out field information with a field count into the `tree-dump.tsv`.

    $ dump-tree.py Naptan.xml tree-dump.tsv

The output is then:

    ...
    NaPTAN	StopPoints	StopPoint	Place	NptgLocalityRef	5
    NaPTAN	StopPoints	StopPoint	Place	LocalityCentre	5
    NaPTAN	StopPoints	StopPoint	Place	Location	Translation	GridType	7
    ...

### Investigate `rail` related fields

Look and count tags related to `rail` fields in the NaPTAN dataset field dump for further analysis:

    $ fgrep -i rail tree-dump.tsv | sort | uniq -c
    2667 NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	AccessArea	7
    2624 NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	AnnotatedRailRef	CrsRef	8
    2624 NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	AnnotatedRailRef	StationName	8
    2624 NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	AnnotatedRailRef	TiplocRef	8
    4533 NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	Entrance	7
       3 NaPTAN	StopPoints	StopPoint	StopClassification	OffStreet	Rail	Platform	7

### Field structure analysis 

Looking at the fields frequency count:

    $ wc -l tree-dump.tsv
    9364219 tree-dump.tsv
    
    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 }' | uniq -c | head -8
    9364219 NaPTAN
    
    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 }' | uniq -c | head -8
    8446623 NaPTAN StopPoints
     917596 NaPTAN StopAreas    
    
    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 "	" $3 }' | uniq -c  | head -8
    8446623 NaPTAN StopPoints StopPoint
     917596 NaPTAN StopAreas  StopArea

    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 "	" $3 "	" $4 }' | uniq -c | head -8
    1 NaPTAN StopPoints StopPoint AtcoCode
    1 NaPTAN StopPoints StopPoint NaptanCode
    3 NaPTAN StopPoints StopPoint Descriptor
    7 NaPTAN StopPoints StopPoint Place

As the frequency analysis shows the NaPTAN data structure consists of `NaPTAN/StopPoints/StopPoint` and `NaPTAN/StopAreas/StopArea` tags.

### Split the data into `StopPoint` and `StopArea` files

Use the `xml-split4.py` and `dump-ndjson.sh` scripts from <https://github.com/anisotropi4/goldfinch>, to remove outer xml-tags to extract data in `StopPoint.xml` and `StopArea.xml` files in the `output` directory: 

    $ xml-split4.py --badxml --depth 2 --path output --split Naptan.xml

Then convert the xml into ndjson (new-line delimited json):

    $  < output/StopArea.xml parallel -j 1 --files --pipe -N1024 add-x-tag.sh | parallel -j 4 "xml-to-ndjson.sh {} StopArea; rm {}" > output/StopArea.ndjson
    $  < output/StopPoint.xml parallel -j 1 --files --pipe -N1024 add-x-tag.sh | parallel -j 4 "xml-to-ndjson.sh {} StopPoint; rm {}" > output/StopPoint.ndjson
