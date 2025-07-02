#!/usr/bin/env bash

for i in {1..5}; do
	ls "$1" | grep User"$i" >> lists/"$1"_filenames_"$i".txt
	python3 scripts/labels.py lists/"$1"_filenames_"$i".txt >> lists/"$1"_labels_"$i".txt
	echo "User $i done"	
done
