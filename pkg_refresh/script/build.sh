#!/bin/bash

source "./refresh.rc"


# file which has list of packages to be build
PackageList="list.txt"
# path of packages directory
PackagePath="bootstrap-plans/"
LogFile="build.log"

function log {
	echo `date "+%Y-%m-%d %H:%M:%S"`" $1" >> $LogFile
}

while IFS= read -r line; do
	# tokenize line
	IFS=' '
	read -a arr <<< "$line"
	#len="${#arr[@]}"
	plan="${arr[0]}"
	args="${arr[1]}"

	if [[ "$args" == "skip" ]];
	then
		log "[$plan] Skip with args [$args]"
		continue
	else
		log "[$plan] Build with args [$args]"
	fi	

	# build command
	cmd="hab pkg build -N $PackagePath"
	cmd="${cmd}$plan"

	log "[$plan] Building [$cmd]"

	start=$(date +%s)
	eval "$cmd"
	end=$(date +%s)

	if [[ $? != 0 ]];
	then
		log "[$plan] ERR Built failed"
		break
	fi

	#log "[$plan] Built in [$(($end-$start))] seconds"
	log "[$plan] Built in [$(date -d@$(($end-$start)) -u +%Hh:%Mm:%Ss)]


done < $PackageList

log "That's all folks!"

exit 1
