#!/bin/bash

# script to verify all packages are present in build order

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <package_list_file> <build_order_file>"
  exit 1
fi

PACKAGE_LIST_FILE="$1"
BUILD_ORDER_FILE="$2"

# Check if package list file exists and is readable
if [ ! -r "$PACKAGE_LIST_FILE" ]; then
  echo "ERR : Package list file '$PACKAGE_LIST_FILE' does not exist or is not readable."
  exit 1
fi

# Check if build order file exists and is readable
if [ ! -r "$BUILD_ORDER_FILE" ]; then
  echo "ERR : Build order file '$BUILD_ORDER_FILE' does not exist or is not readable."
  exit 1
fi

# Read each line from package list
while IFS= read -r package || [ -n "$package" ]; do
  # Skip empty lines
  if [ -z "$package" ]; then
    continue
  fi

  # Search the package string in build order file
  if ! grep -Fxq "$package" "$BUILD_ORDER_FILE"; then
    echo "ERR : [$package] not found in build order file."
  fi
done < "$PACKAGE_LIST_FILE"

