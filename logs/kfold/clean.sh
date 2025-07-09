#!/usr/bin/env bash
for file in "$1"; do
	if [[ -f "$file" ]]; then
		sed 's/,\s*$//' "$file" > clean/"$1"/"$file"
	fi
done
