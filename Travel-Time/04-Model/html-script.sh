#!/bin/bash
cat <<EOF
<!DOCTYPE html>
<html>
    <head>
        <title>Combined Public Transport and Rail Travel Times</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
         * {
             font-family: sans;
             text-align: center;
         }
         h2 {
             font: 14px arial, sans-serif;
         }
         h3 {
             font: 12px arial, sans-serif;
         }
         .row {
             float: none;
         }
         .thumbnail {
             width: 200px;
             text-align: center;
         }
         .container {
             float: none;
         }
         .caption {
             text-align: left;
         }
         img {
             border: 1px solid #ddd;
             border-radius: 4px;
             padding: 4px;
             width: 180px;
         }
         .img {
             background-color: black;
         }
        </style>
    </head>
    <body>
        <h1>UK Rail Travel Times Gallery</h1>
        <h2>Visualisation based on Department of Transport combined Public Transport and Rail Travel-Time data<br>The project directory is <a href="https://github.com/anisotropi4/wren/tree/master/Travel-Time" target="_blank">here</a></h2>
        <div class="content">
            <table>
                <thead>
                    <tr>
                        <th><h2>Station Name<br><br>CRS Code</h3></th>
                        <th><h2>AM peak<br>(7am to 10am)</h2></th>
                        <th><h2>Mid peak<br>(10am to 4pm)</h2></th>
                        <th><h2>PM peak<br>(4pm to 7pm)</h2></th>
                        <th><h2>Late<br>(7pm to midnight)</h2></th>
                    </tr>
                </thead>
                <tbody>
EOF

for CRS in ABD ADV ASI BAN BBN BDI BDM BFR BHI BHM BIC BKG BMH BMO BMS BNG BON BPN BPW BRE BRI BSK BSW BTH BTN BWK CAR CBE CBG CDF CDQ CHD CHM CHX CLJ CLT CNM COL COV CPM CRE CST CTK CTM CTR DAR DBY DEE DFD DHM DID DKG DON EAL EBF EBN ECR EDB EGR EMD EPS ESL EUS EXC EXD FKC FST GCR GLC GLD GLM GLQ GRA GTW HFD HGS HGT HHE HRW HUD HUL HWN HWY IFD INV IPS KGX KNG LAN LBG LBO LCN LDS LEI LIV LMS LPY LST LUT LVC MAC MAI MAN MBR MCO MCV MDE MIA MKC MYB NBY NCL NMP NNG NOT NRW NTA NUN NWP NXG OXF PAD PBO PLY PMH PMS PNZ POO PRE PTH PUT RAY RDG RDH RMD RMF RUG RUN SAL SCA SEV SHF SHR SLO SNF SOA SOC SOT SOU SOV SPL SPT SRA SSD STA SUR SVG SWA SWI SYL TAU TBD TBW TON TRU TWI VIC VXH WAE WAT WBQ WEY WFJ WGC WGN WIM WIN WKF WNR WOK WOS WVH YRK
do
    i=$(fgrep ${CRS} stations | sed 's/^.*\t//')
    cat <<EOF
    <tr>
    <td>${i}<br><br>${CRS}</td>
    <td><div class="thumbnail"><a href="images/topo-${CRS}-PT_01.png" target="${CSR}01"><img src="images/topo-${CRS}-PT_01.png" alt="${CRS}, ${i}, Public Transport, Early"></a></td>
    <td><div class="thumbnail"><a href="images/topo-${CRS}-PT_02.png" target="${CSR}02"><img src="images/topo-${CRS}-PT_02.png" alt="${CRS}, ${i}, Public Transport, Early"></a></td>
    <td><div class="thumbnail"><a href="images/topo-${CRS}-PT_03.png" target="${CRS}03"><img src="images/topo-${CRS}-PT_03.png" alt="${CRS}, ${i}, Public Transport, Early"></a></td>
    <td><div class="thumbnail"><a href="images/topo-${CRS}-PT_04.png" target="${CRS}04"><img src="images/topo-${CRS}-PT_04.png" alt="${CRS}, ${i}, Public Transport, Early"></a></td>
    </tr>
EOF

done

cat <<EOF
    </tbody>
</table>
EOF
