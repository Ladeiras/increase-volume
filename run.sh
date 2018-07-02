#!/bin/bash

# if [[ $1 ]]; then
# 	test -d videos || mkdir videos
# 	rm videos/*

# 	while IFS='' read -r url || [[ -n $url ]]; do
# 		printf "\n\nDownloading $url...\n\n"
# 		#cd videos && { curl -O -J "$url" ; cd -; }
# 		cd videos && { wget $url ; cd -; }
# 	done < "urls"

# 	test -d output || mkdir output
# 	rm output/*
	
# 	cd videos
# 	for file in ./*
# 		do
# 		if [[ -f $file ]]; then
# 			printf "\n\nConverting $url...\n\n"
# 			ffmpeg -i "$file" -vcodec copy -af volume=$1 ../output/"$file"
# 		fi
# 	done
# 	cd -
# else
# 	printf "\nMissing parameter\n\ne.g. Multiply volume by 10:\n./run.sh 10\n\n"
# fi

mode=download
volume=2
crf=24

usage() {
	cat << EOF >&2

Usage: run.sh [-m <mode>] [-v <volume>] [-crf <crf>]

-m <mode> : 'download' or 'tweak' (default 'download')
-v <volume> : Volume multiplier (default 2)
-crf <crf>: CRF (default 24)

EOF
}

parse_args() {
	case "$1" in
		-m)
			mode="$2"
			;;
		-v)
			volume="$2"
			;;
		-crf)
			crf="$2"
			;;
		*)
			usage
			exit 1
			;;
	esac
}

while [[ "$#" -ge 2 ]]; do
    parse_args "$1" "$2"
    shift; shift
done

printf "\n\n$volume $framerate\n\n"


if [[ "$mode" = "download" ]]; then
	test -d videos || mkdir videos
	rm videos/*

	while IFS='' read -r url || [[ -n $url ]]; do
		printf "\n\nDownloading $url...\n\n"
		#cd videos && { curl -O -J "$url" ; cd -; }
		cd videos && { wget $url ; cd -; }
	done < "urls"
fi

test -d output || mkdir output
rm output/*

cd videos
for file in ./*
	do
	if [[ -f $file ]]; then
		printf "\n\nConverting $url...\n\n"
		ffmpeg -i "$file" -vcodec libx264 -crf $crf -af volnorm=1 -af volume=$volume ../output/"$file"
	fi
done
cd -