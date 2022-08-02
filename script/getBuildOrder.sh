#!/bin/bash

# Brief : Script does not generated build order (of package dependency tree).
# It uses buildorder used in last full refresh to fetch related build order of particular package.
# Usecase: If a package is updated out of refresh then its rdep packages needs to be updated as well
# in that case use this script to fetch build order of relevant packages 

BUILD_ORDER=$1
PKG_LIST=$2

cat $BUILD_ORDER | while read line ;
do
	if grep -Fxq "$line" $PKG_LIST
	then
		#line is present in pkg list
		echo "$line";
	#else
		#line is absent
	fi
done
