#!/usr/bin/env bash

cd "$1" || exit

for X in {A,B,C,D,E}
do
	mkdir Location"$X"
	mv *Location"$X"_* Location"$X"
	echo "Location$X done"
done
