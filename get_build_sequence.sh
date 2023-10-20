#!/bin/bash

# a script to generate build sequence based on build-order used in last refresh.
# file_bo - file has build order which had worked in last refresh
# file_input - file having list of packages needs to be arranged in sequence based in dependency tree
# file_output - file having sequence of packages as per dependency tree for build/refresh

file_bo="build_order"
file_input="pkg_list"
file_output="pkg_sequence"

echo "args : $#\n"
if [ "$#" -eq 1 ];
then
	file_input=$1
fi

# get build-order data from GitHub
$(rm -f $file_bo)
curl -s https://raw.githubusercontent.com/habitat-sh/habitat-coreplan-refresher/main/config/refresh_list.txt?token=GHSAT0AAAAAACD2GQRF7CZH7COAUFAL5F5SZHIWGVQ > $file_bo

# delete already existing file
$(rm -f $file_output)

# iterate through file "file_bo" and if package is present in unsorted list write to final file
while IFS= read -r line; do
	#echo "$line"

	if grep -Fxq "$line" $file_input; then
		# if found
		echo "Found [$line] in build order"
		echo "$line" >> $file_output
	fi
done < "$file_bo"

echo "Build sequence is generated, check file [$file_output]\n"
