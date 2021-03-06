# Scrub and Explore

As the content of the National Public Transport Access Nodes (NaPTAN) rail visualisation appears to be clean, the Scrub and Explore stages are combined.

The `investigate.sh` script contains the elements used to explore the data which looks to extract geographic rail information from the NaPTAN dataset for visualisation.

## Assumptions  

The Explore activities assume

  * `jq` tool is installed (https://stedolan.github.io/jq/)
  * `BaseX` XML Database engine is installed. Details about the database engine can be found here 'http://basex.org/'. On a Debian based Linux version to install `basex` run:  
    
    $ sudo apt install basex

  * `parallel` tool is installed

    $ sudo apt install parallel

  * A copy of the 'Naptan.xml' data is in the '01-Obtain' directory

## Load the Data and look at the Data Structure

### Load the Data into a BaseX database engine

As the `Naptan.xml` file is large (~582MB), the first step to look at the data-structure. This involves importing the xml file into the BaseX database engine. On the command line this involves:

    $ basex
    > CREATE DB NaPTAN Naptan.xml
    Database 'NaPTAN' created in 89931.92 ms.
    > quit
    Have a nice day.

### Dump field information

Running the following `xpath` script `tree-dump.xq` and shell script to tidy-up the output (remove head/footer noise plus reorder fields) against the NaPTAN data dumps out field information with a field count into the `tree-dump.tsv`.

    < tree-dump.xq basex | sed '/^$/d' | tail -n +5 | sed 's/^\([ 0-9]*\) \(.*$\)/\2\t\1/' | head -n -2 > tree-dump.tsv

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
    
    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 }' | uniq -c | head -4
    9364219 NaPTAN
    
    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 }' | uniq -c | head -4
    8446623 NaPTAN StopPoints
     917596 NaPTAN StopAreas    
    
    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 "	" $3 }' | uniq -c  | head -4
    8446623 NaPTAN StopPoints StopPoint
     917596 NaPTAN StopAreas  StopArea

    $ < tree-dump.tsv awk 'BEGIN { FS="\t" } { print $1 "	" $2 "	" $3 "	" $4 }' | uniq -c | head -4
    1 NaPTAN StopPoints StopPoint AtcoCode
    1 NaPTAN StopPoints StopPoint NaptanCode
    3 NaPTAN StopPoints StopPoint Descriptor
    7 NaPTAN StopPoints StopPoint Place

As the frequency analysis shows the NaPTAN data structure consists of `NaPTAN/StopPoints/StopPoint` and `NaPTAN/StopAreas/StopArea`.

### Split the data into `StopPoint` and `StopArea` files

Using the `dump-xml.sh` and `dump-ndjson.sh` scripts from <https://github.com/anisotropi4/goldfinch>, extract data in `StopPoint.xml` and `StopArea.xml` files in the `output` directory and convert the xml into ndjson (new-line delimited json).
