#!/bin/bash

file="core_linux2"

for OUTPUT in $(cat $file);
do
	#echo "hab promote $OUTPUT stable x86-64-linux"
	hab pkg promote $OUTPUT stable x86_64-linux-kernel2;
done
