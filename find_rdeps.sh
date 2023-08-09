#!/bin/bash

# A script to find dependents(rdeps) and transitive dependents(trdeps) of a habitat package.
# output will be saved in file "allrdep"

# e.g. add package names to file "rdep" (inout file)
# $ cat rdep 
# core/openssl
# core/cacerts

filter="^core\/*"
file_rdep="rdep"
file_trdep="rdep_next"
file_allrdep="allrdep"

# get all dependents of package and save in file
getDependents () {
	# BLDR api to get all dependents
	local ret=0
	local out=$(curl -s https://api.habitat.sh/v1/rdeps/$1?target=x86_64-linux | jq -r '.rdeps[]' | grep "$filter")
	if [ -z "$out" ] 
	then {
		# out is empty
		echo "ERR: [$1] no dependents found"
		ret=1
	} else {
		# write in file
		printf "$out\n" >> $2
		echo "INFO: [$1] dependents saved in file [$2]"
	} fi

	return $ret
}

# delete existing file
`rm -f $file_allrdep`

# get all dependents of the package and save in file

loop=1

while [ $loop ]:
do
	# read rdep file and get all dependents
	while IFS= read -r line;
       	do
		getDependents $line $file_trdep
	done < "$file_rdep"

	echo "DBUG: Found level $loop rdep\n\n"

	# if file is empty then break
	if [ ! -s "$file_trdep" ]
	#if [ -z "$(cat $file_trdep)" ]
	then
		`rm -f $file_rdep`
		`rm -f $file_trdep`
		break
	fi

	# move rdep to final destination
	`cat $file_rdep | sort -u >> $file_allrdep`
	`rm -f $file_rdep`

	# move to trdep to rdep
	`cat $file_trdep | sort -u >> $file_rdep`
	`rm -f $file_trdep`

	# increament loop counter
	loop=$(expr $loop + 1)
done
