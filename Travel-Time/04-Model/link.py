#!/usr/bin/env python3

import os, sys

header = True
with open('stationorder') as file_data:
    for file_line in file_data:
        if header:
            header = False
            continue
        (n, crs, _, _) = file_line.rstrip().split('\t')
        for i in range(1,5):
            from_file = 'images/topo-{0}-PT_0{1}.png'.format(crs, i)
            to_file = 'frames/topo-{0}-PT_0{1}.png'.format(n, i)
            os.link(from_file, to_file)
