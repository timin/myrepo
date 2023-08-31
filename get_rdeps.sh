#!/bin/bash

# A script to find dependents(rdeps) and transitive dependents(trdeps) of a habitat package.
# output will be saved in file "output"

# e.g. add package names to file "input" (input file)
# $ cat input
# core/openssl
# core/cacerts

#usage: get_rdeps.sh core/openssl

filter="^core\/\|^habitat\/\|^chef\/"

file_input="input"
file_interim="interim"
file_output="output"

# possible values : linux, linux2, aarch, macos
platform="linux2"

main() {
	architecture=""

	printf "args : $#\n"
	if [ "$#" -gt 0 ];
	then
		# delete existing file
		$(rm -f $file_input)

		# save package name in input file
		echo "$1" > $file_input
		printf "DBUG: creating input file\n"
	else
		printf "DBUG: using existing input file\n"
	fi

	# delete output file if exists
	$(rm -f $file_output)

	# get all dependents of the package and save in file

	loop=1

	# get platform name
	case "$platform" in
	'linux')
		architecture="x86_64-linux"
		;;
	'linux2')
		architecture="x86_64-linux-kernel2"
		;;
	'aarch')
		architecture="aarch64"
		;;
	*)
		architecture="linux"
		;;
	esac

	printf "DBUG: getting runtime rdep for [$architecture] platform\n"

	while [ $loop ]:;
	do
		# read input file and get all dependents
		while IFS= read -r line;
		do
			getDependents $line $architecture $file_interim
			ret=$?
			if [ $ret -eq 0 ];then
				printf "DBUG: [$line] fetched rdeps\n"
			else
				printf "ERR: [$line] unable to fetch rdeps; ret[$ret]\n"
			fi
		done < "$file_input"

		printf "DBUG: got [level $loop] rdeps\n\n"

		# if file is empty then break
		if [ ! -s "$file_interim" ]; then #if [ -z "$(cat $file_interim)" ]
			# move input file to output file
			$(cat $file_input | sort -u >> $file_output)
			$(rm -f $file_input)
			$(rm -f $file_interim)

			printf "INFO: runtime dependents can be found in file [$file_output]\n"
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

# get all dependents of package and save in file
getDependents() {
	# builder api to get all dependents
	local ret=1
	local out=$(curl -s https://api.habitat.sh/v1/rdeps/$1?target=$2 | jq -r '.rdeps[]' | grep "$filter")
	if [ -z "$out" ]; then {
		# out is empty
		#printf "WARN: [$1] oops! no dependents\n"
		ret=1
	} else {
		# write in file
		echo "$out" >> $3
		#printf "INFO: [$1] dependents saved in file [$3]\n"
		ret=0
	} fi

	return $ret
}


main $@ || exit 99
