#!/bin/bash

# Brief : script to fetch all packages in given builer channel
# In : update PKG_ORIGIN and PKG_CHANNEL as per need

PKG_ORIGIN="core"
PKG_CHANNEL="refresh_xlib"

INDEX_START=0
INDEX_END=1
FILE="/tmp/channel_packages.txt"

# delete file if present
rm -f $FILE

# fetch packages from BLDR channel
while [ "$INDEX_START" -lt "$INDEX_END" ]
do
	result=""
	result="$(curl -s "https://bldr.habitat.sh/v1/depot/channels/${PKG_ORIGIN}/${PKG_CHANNEL}/pkgs?range=${INDEX_START}")"

	INDEX_START=$(echo ${result} | jq -r '.range_end')+1
	((INDEX_START=INDEX_START+1))
	INDEX_END=$(echo ${result} | jq -r '.total_count')

	echo ${result} | jq -r '.data[] | .origin + "\/" + .name + "\/" + .version + "\/" + .release' >> $FILE
done

echo "Total package fetched : $INDEX_END"
cat $FILE
rm -f $FILE
