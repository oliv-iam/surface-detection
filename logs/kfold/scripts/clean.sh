#!/usr/bin/env bash
for file in *; do
	if [[ -f "$file" ]]; then
		sed 's/,\s*$//' "$file" > clean/"$file"
	fi
done
