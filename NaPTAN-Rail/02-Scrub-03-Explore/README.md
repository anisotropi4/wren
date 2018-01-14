# Scrub and Explore  

As the content of the National Public Transport Access Nodes (NaPTAN) Rail visualisation appears to be clean, the Scrub and Explore stages are combined.

The `investigate.sh` script contains the elements used to explore the data.

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

Running the following `xpath` script `tree-dump.xq` and shell script to tidy-up the output (remove head/footer noise plus reorder fields) against the NaPTAN data dumps out tag information with a field count into the `tree-dump.tsv`.

    < tree-dump.xq basex | sed '/^$/d' | tail -n +5 | sed 's/^\([ 0-9]*\) \(.*$\)/\2\t\1/' | head -n -2 > tree-dump.tsv

The output is then:

    ...
    NaPTAN	StopPoints	StopPoint	Place	NptgLocalityRef	5
    NaPTAN	StopPoints	StopPoint	Place	LocalityCentre	5
    NaPTAN	StopPoints	StopPoint	Place	Location	Translation	GridType	7
    ...

### Field structure frequency analysis 

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

### Split the data into `StopPoint` and `StopArea` field

This shows the NaPTAN data is split into `NaPTAN/StopPoints/StopPoint` and `NaPTAN/StopAreas/StopArea` data-structures. For the next step, extract this into `StopPoint.xml` and `StopArea.xml` files, and convert these into `.ndjson` files using the `dump-xml.sh` and `dump-ndjson.sh` scripts ahead of further analysis.


