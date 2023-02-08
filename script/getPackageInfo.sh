#!/bin/bash

# brief: Script to get packages information from Habitat Builder

cCount="0"
tCount=$(curl -s http://ec2-34-227-194-219.compute-1.amazonaws.com/v1/depot/channels/core/stable/pkgs?range=0 | jq -r '.total_count')

while [ $cCount -lt $tCount ]; do
	startRange="0"
	endRange="0"

	url="curl -s http://ec2-34-227-194-219.compute-1.amazonaws.com/v1/depot/channels/core/stable/pkgs?range=$cCount"
	#echo "URL : $url"
	response=$($url)

	startRange=$(echo $response | jq -r '.range_start')
	endRange=$(echo $response | jq -r '.range_end')

	value=$(echo $response | jq -r '.data[] | .origin + "/" + .name + "," + .version')
	echo "$value"

	cCount=$((endRange + 1))
done
