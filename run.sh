#!/bin/bash

if [[ $1 ]]; then
	test -d videos || mkdir videos
	rm videos/*

	while IFS='' read -r url || [[ -n $url ]]; do
		printf "\n\nDownloading $url...\n\n"
		#cd videos && { curl -O -J "$url" ; cd -; }
		cd videos && { wget $url ; cd -; }
	done < "urls"

	test -d output || mkdir output
	rm output/*
	
	cd videos
	for file in ./*
		do
		if [[ -f $file ]]; then
			printf "\n\nConverting $url...\n\n"
			ffmpeg -i $file -vcodec copy -af volume=$1 ../output/$file
		fi
	done
	cd -
else
	printf "\nMissing parameter\n\ne.g. Multiply volume by 10:\n./run.sh 10\n\n"
fi
