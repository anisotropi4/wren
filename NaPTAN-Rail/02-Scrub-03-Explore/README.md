# Scrub and Explore  

As the content of the National Public Transport Access Nodes (NaPTAN) Rail visualisation appears to be clean, the Scrub and Explore stages are combined.

## Assumptions  

The Explore activities assume

  * `jq` tool is installed (https://stedolan.github.io/jq/)
  * `baseX` XML Database engine is installed. Details about the database engine can be found here 'http://basex.org/'. On a Debian based Linux version to install `basex` run:  
    
    $ sudo apt install basex

  * `parallel` tool is installed

    $ sudo apt install parallel

  * A copy of the 'Naptan.xml' data is in the '01-Obtain' directory

## Identify key  

