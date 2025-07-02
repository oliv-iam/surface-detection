#!/usr/bin/env bash

for u in User1 User2 User3 User4 User5; do
	for l in A B C D E; do
		ls set"$1" | grep "$u"_Location"$l" | wc -l >> counts.txt
	done
done
