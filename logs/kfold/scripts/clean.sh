#!/usr/bin/env bash

mkdir clean/"$1"
for file in "$1"/*; do
	if [[ -f "$file" ]]; then
		echo "$file"
		sed 's/,\s*$//' "$file" > clean/"$file"
	fi
done
