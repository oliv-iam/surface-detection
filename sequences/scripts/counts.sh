#!/usr/bin/env bash

for i in {1..5}; do
	for j in {"A","B","C","D","E"}; do
		echo "User $i, Location $j:"
		ls "$1" | grep User"$i"_Location"$j" | wc -l
	done
done
