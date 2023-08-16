#!/bin/bash

# A script to find dependents(rdeps) and transitive dependents(trdeps) of a habitat package.
# output will be saved in file "allrdep"

# e.g. add package names to file "rdep" (inout file)
# $ cat rdep
# core/openssl
# core/cacerts

filter="^core\/\|^habitat\/\|^chef\/"
file_input="input"
file_interim="interim"
file_output="output"

# get all dependents of package and save in file
getDependents() {
	# BLDR api to get all dependents
	local ret=0
	local out=$(curl -s https://api.habitat.sh/v1/rdeps/$1?target=x86_64-linux | jq -r '.rdeps[]' | grep "$filter")
	if [ -z "$out" ]; then {
		# out is empty
		echo "ERR: [$1] no dependents found"
		ret=1
	}; else {
		# write in file
		printf "$out\n" >> $2
		echo "INFO: [$1] dependents saved in file [$2]"
	}; fi

	return $ret
}

main() {
	# delete existing file
	$(rm -f $file_input)
	$(rm -f $file_output)

	# save package name in input file
	echo "$1"
	echo "$1" > $file_input

	# get all dependents of the package and save in file

	loop=1

	while [ $loop ]:; do
		# read rdep file and get all dependents
		while IFS= read -r line; do
			getDependents $line $file_interim
		done < "$file_input"

		echo "DBUG: Found level $loop rdep\n\n"

		# if file is empty then break
		if [ ! -s "$file_interim" ]; then #if [ -z "$(cat $file_interim)" ]
			$(rm -f $file_input)
			$(rm -f $file_interim)

			echo "dependents packages are found in $file_output"
			break
		fi

		# move input file to output file
		$(cat $file_input | sort -u >> $file_output)
		$(rm -f $file_input)

		# move to interim file to input file
		$(cat $file_interim | sort -u >> $file_input)
		$(rm -f $file_interim)

		# increament loop counter
		loop=$(expr $loop + 1)
	done
}

main $1
