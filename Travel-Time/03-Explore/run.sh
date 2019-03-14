#!/bin/bash -x
# Train travel-time data for Public Transport links for all stations

HEIGHT=960
WIDTH=640

PROJECTION='d3.geoConicEqualArea().parallels([49, 61]).fitSize(['${WIDTH}','${HEIGHT}'], d)'

TIMESTEP=30.0
SCALE="d3.scaleLinear().domain([450, 0]).clamp(true)(d3.format('.0f')(d.properties.time / "${TIMESTEP}") * "${TIMESTEP}")"

#FILL="d3.interpolateYlOrRd(d.properties.scale)"
FILL="d3.interpolatePlasma(d.properties.scale)"
#FILL="d3.schemeSpectral[11][d.properties.scale]"

        
if [ ! -f LLSOA-2001-England-and-Wales.ndjson ]
then
    ln ../02-Scrub/LLSOA-2001-England-and-Wales.ndjson
fi

for CRS in ABD ADV ASI BAN BBN BDI BDM BFR BHI BHM BIC BKG BMH BMO BMS BNG BON BPN BPW BRE BRI BSK BSW BTH BTN BWK CAR CBE CBG CDF CDQ CHD CHM CHX CLJ CLT CNM COL COV CPM CRE CST CTK CTM CTR DAR DBY DEE DFD DHM DID DKG DON EAL EBF EBN ECR EDB EGR EMD EPS ESL EUS EXC EXD FKC FST GCR GLC GLD GLM GLQ GRA GTW HFD HGS HGT HHE HRW HUD HUL HWN HWY IFD INV IPS KGX KNG LAN LBG LBO LCN LDS LEI LIV LMS LPY LST LUT LVC MAC MAI MAN MBR MCO MCV MDE MIA MKC MYB NBY NCL NMP NNG NOT NRW NTA NUN NWP NXG OXF PAD PBO PLY PMH PMS PNZ POO PRE PTH PUT RAY RDG RDH RMD RMF RUG RUN SAL SCA SEV SHF SHR SLO SNF SOA SOC SOT SOU SOV SPL SPT SRA SSD STA SUR SVG SWA SWI SYL TAU TBD TBW TON TRU TWI VIC VXH WAE WAT WBQ WEY WFJ WGC WGN WIM WIN WKF WNR WOK WOS WVH YRK
do
    for i in PT_AM PT_Mid PT_PM PT_Late HW_AM HW_Mid HW_PM
    do
        if [ ! -f Stations_${i}.ndjson ]
        then
            ln ../02-Scrub/Stations_${i}.ndjson
        fi
        # round time to nearest minute
        # if the time element is absent sets an arbitrary value of 999.9 minutes 
        if [ ! -s output/topo-${CRS}-${i}.json ]
        then
            geo2topo -n tracts=<(ndjson-join --left 'd.id' \
                                             <(jq -s -c '{"type": "FeatureCollection", "features": .}' LLSOA-2001-England-and-Wales.ndjson | \
                                                      geoproject "${PROJECTION}" | \
                                                      jq -c '.features[]') \
                                             <(jq -c 'select(.CRS=="'${CRS}'") | del(.CRS) | to_entries | map({id: .key, time: (.value | tonumber | . + 0.5 | floor)})[]' Stations_${i}.ndjson) | \
                                        ndjson-map '{type: d[0].type, properties: {title: d[0].id, time: (d[1] != null && d[1].time || 999.9)}, geometry: d[0].geometry}') | \
                toposimplify -p 1 -f | \
                topoquantize 1E6 > output/topo-${CRS}-${i}.json
        fi
        
        if [ ! -s output/topo-${CRS}-${i}.svg ]
        then
            < output/topo-${CRS}-${i}.json topo2geo -n tracts=- | \
                ndjson-map -r d3 '(d.properties.scale='"${SCALE}"',d)' | \
                ndjson-map -r d3=d3-scale-chromatic '(d.properties.fill='"${FILL}"', d)' | \
                geo2svg --stroke=none -n -p 1 -w ${WIDTH} -h ${HEIGHT} > output/topo-${CRS}-${i}.svg 
        fi
    done
done

# Create
for CRS in ABD ADV ASI BAN BBN BDI BDM BFR BHI BHM BIC BKG BMH BMO BMS BNG BON BPN BPW BRE BRI BSK BSW BTH BTN BWK CAR CBE CBG CDF CDQ CHD CHM CHX CLJ CLT CNM COL COV CPM CRE CST CTK CTM CTR DAR DBY DEE DFD DHM DID DKG DON EAL EBF EBN ECR EDB EGR EMD EPS ESL EUS EXC EXD FKC FST GCR GLC GLD GLM GLQ GRA GTW HFD HGS HGT HHE HRW HUD HUL HWN HWY IFD INV IPS KGX KNG LAN LBG LBO LCN LDS LEI LIV LMS LPY LST LUT LVC MAC MAI MAN MBR MCO MCV MDE MIA MKC MYB NBY NCL NMP NNG NOT NRW NTA NUN NWP NXG OXF PAD PBO PLY PMH PMS PNZ POO PRE PTH PUT RAY RDG RDH RMD RMF RUG RUN SAL SCA SEV SHF SHR SLO SNF SOA SOC SOT SOU SOV SPL SPT SRA SSD STA SUR SVG SWA SWI SYL TAU TBD TBW TON TRU TWI VIC VXH WAE WAT WBQ WEY WFJ WGC WGN WIM WIN WKF WNR WOK WOS WVH YRK
do
    for i in PT_AM PT_Mid PT_PM PT_Late HW_AM HW_Mid HW_PM
    do
	ln output/topo-${CRS}-${i}.svg $(ls output/topo-${CRS}-${i}.svg | sed 's/_AM/_01/;s/_Mid/_02/;s/_PM/_03/;s/_Late/_04/')
    done
done

