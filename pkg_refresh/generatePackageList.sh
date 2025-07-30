#!/bin/bash

# script to generate list of packages for x86_64-linux platfrom from core-plans repo

# Check if argument is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <path_to_core-plans_repo>"
  exit 1
fi

# Set start directory to $PWD or to the first argument if given
REPO_DIR="${1:-$PWD}"
OUTPUT_FILE="packageList.txt"

# Empty output file before writing
> "$OUTPUT_FILE"

echo "INFO : searching for planfiles (plan.sh) under: $REPO_DIR"
echo "INFO : excluding deprecated, test & x86_64-linux-kernel2 platform planfile"

find "$REPO_DIR" -type f -name "plan.sh" | grep -v "linux-kernel2\|.deprecated\|tests" | while read -r file
do
	abs_path="$(realpath "$file")"
	source "$abs_path"
	#echo "$pkg_origin/$pkg_name" >> "$OUTPUT_FILE"
	echo "$pkg_name" >> "$OUTPUT_FILE"
done

echo "INFO : list of package name have been written to $OUTPUT_FILE"
