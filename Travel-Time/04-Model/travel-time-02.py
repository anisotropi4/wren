#!/usr/bin/env python3
import sys
import csv
import re
from os import listdir
from collections import OrderedDict

with open('stations') as file_data:
    tsv_in = csv.reader(file_data, delimiter='\t')
    stations = dict([i for i in tsv_in])

images_list = listdir('images')


this_value = 'PT'
if len(sys.argv) > 1:
    this_value = sys.argv[1]

output = {}
image_split = re.compile('[._-]')
for image_file in images_list:
    try:
        (_, crs, transport_type, _, _) = image_split.split(image_file)
        if transport_type != this_value: continue
        if crs not in output:
            output[crs] = [image_file]
        else:
            output[crs].append(image_file)
    except ValueError:
        pass

time_lookup = {'01': 'Early', '02': 'Midday', '03': 'Evening', '04': 'Late'}

def alt_str(image_file):
    (_, crs, type, i, _) = image_split.split(image_file)
    return'{}, {}, Public Transport, {}'.format(stations.get(crs), crs, time_lookup[i])

def this_str(output_str, n):
    return '|'.join(output_str.split('|')[:n]) + '|'

n = len(next(iter(output.values())))
print('title: base Travel-Time images table')
print('body: |')
print(this_str(' |Station Name<br>CRS Code|AM peak<br>(07:00-10:00)|Mid peak<br>(10:00-16:00)|Evening peak<br>(16:00-19:00)|Late<br>(19:00-00:00)', n+2))
print(this_str(' |:-----:|:-----:|:-----:|:-----:|:-----:|', n+2))

for i, j in sorted(output.items()):
    print(' |{}<br>{}|{}|'.format(stations.get(i), i, '|'.join(['![{0}](images/{1})'.format(alt_str(this_image), this_image) for this_image in sorted(j)])))
