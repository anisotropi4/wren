sed 's/"//g' | jq --slurp --raw-input --raw-output -c 'split("\n") | map(split(",")) | .[] | select(.[0] != null) | {CRS: .[3], (.[0]): .[1]}'

