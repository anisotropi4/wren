#!/bin/bash
# Train travel-time data for Public Transport links for all stations

for CRS in ABD ADV ASI BAN BBN BDI BDM BFR BHI BHM BIC BKG BMH BMO BMS BNG BON BPN BPW BRE BRI BSK BSW BTH BTN BWK CAR CBE CBG CDF CDQ CHD CHM CHX CLJ CLT CNM COL COV CPM CRE CST CTK CTM CTR DAR DBY DEE DFD DHM DID DKG DON EAL EBF EBN ECR EDB EGR EMD EPS ESL EUS EXC EXD FKC FST GCR GLC GLD GLM GLQ GRA GTW HFD HGS HGT HHE HRW HUD HUL HWN HWY IFD INV IPS KGX KNG LAN LBG LBO LCN LDS LEI LIV LMS LPY LST LUT LVC MAC MAI MAN MBR MCO MCV MDE MIA MKC MYB NBY NCL NMP NNG NOT NRW NTA NUN NWP NXG OXF PAD PBO PLY PMH PMS PNZ POO PRE PTH PUT RAY RDG RDH RMD RMF RUG RUN SAL SCA SEV SHF SHR SLO SNF SOA SOC SOT SOU SOV SPL SPT SRA SSD STA SUR SVG SWA SWI SYL TAU TBD TBW TON TRU TWI VIC VXH WAE WAT WBQ WEY WFJ WGC WGN WIM WIN WKF WNR WOK WOS WVH YRK
do

    for i in PT_01 PT_02 PT_03 PT_04 HW_01 HW_02 HW_03
    do
        if [ -f ../03-Explore/output/topo-${CRS}-${i}.svg -a ! -f images/topo-${CRS}-${i}.png ]
        then
            svgexport ../03-Explore/output/topo-${CRS}-${i}.svg  /tmp/topo-${CRS}-${i}.png.$$
            convert /tmp/topo-${CRS}-${i}.png.$$ -background white -flatten frames/topo-${CRS}-${i}.png
	    convert /tmp/topo-${CRS}-${i}.png.$$ -transparent white images/topo-${CRS}-${i}.png
        fi
    done
done

#./html-script.sh > index.html

if [ ! -f output.mp4 ]; then
    ./link.py

    for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32
    do
	ln start_0.png.template frames/start_${i}.png
    done
    
    ffmpeg -framerate 6 -pattern_type glob -i 'frames/*.png' -c:v libx264 -pix_fmt yuv420p output.mp4
fi

for i in HW PT
do
    if [ ! -f ${i}_legend.svg ]; then
	ln ../03-Explore/${i}_legend.svg
    fi
done

if [ ! -f output.html ]; then
    # create output.html file based
    output-html.py --yaml head.yaml head.html
    scrape -e 'article' head.html | sed 's/[\t ][\t ]*$//' > 02-head-article.html
    grep -Fwvxf 02-head-article.html head.html > 01-head-main.html

    sed -i '/^\s*$/d' 01-head-main.html

    tail -1 02-head-article.html > 04-tail.html
    sed -i '$d' 02-head-article.html

    tail -1 01-head-main.html >> 04-tail.html
    sed -i '$d' 01-head-main.html
    
    ./travel-time-02.py HW > body.yaml
    output-html.py --yaml body.yaml body.html
    scrape -e table body.html | sed 's/[\t ][\t ]*$//' > 03-body-table.html
    
    cat 01-head-main.html 02-head-article.html 03-body-table.html 04-tail.html > output.html
fi

if [ ! -f public.html ]; then
    # create output.html file based
    output-html.py --yaml head.yaml head.html
    scrape -e 'article' head.html | sed 's/[\t ][\t ]*$//' > 02-head-article.html
    grep -Fwvxf 02-head-article.html head.html > 01-head-main.html

    sed -i '/^\s*$/d' 01-head-main.html

    tail -1 02-head-article.html > 04-tail.html
    sed -i '$d' 02-head-article.html

    tail -1 01-head-main.html >> 04-tail.html
    sed -i '$d' 01-head-main.html
    
    ./travel-time-02.py PT > body.yaml
    output-html.py --yaml body.yaml body.html
    scrape -e table body.html | sed 's/[\t ][\t ]*$//' > 03-body-table.html
    
    cat 01-head-main.html 02-head-article.html 03-body-table.html 04-tail.html > public.html
fi
