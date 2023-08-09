#!/bin/bash

# a script to generate build order based on build-order used in last refresh.
# file_bo - file has build order which had worked in last refresh
# file_jumble - file having jumbled set of packages needs to order for build
# file_order - resultant set of package order as per last Build Order

file_bo="bo.txt"
file_jumble="rdep.txt"
file_order="order.txt"

# delete already existing file
`rm -f $file_order`

# iterate through file "file_bo" and if package is present in unsorted list write to final file
while IFS= read -r line;
do
	#echo "$line"

	if grep -Fxq "$line" $file_jumble
	then
		# if found
		echo "Found [$line] in build order"
		echo "$line" >> $file_order
	fi
done < "$file_bo"

echo "Build order is generated, check file [$file_order]\n"
