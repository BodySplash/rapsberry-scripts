#!/bin/sh
ROOT_DIR=/mnt/Videos

doUnrar() {
	dirName=`basename $DIR`
	dir=`expr match "$dirName" '\(.*\)\.S[0-9]*E[0-9]*.*'`
	makeDir $ROOT_DIR/$dir
	unrar e $1 $ROOT_DIR/$dir
	dlSubtitles $ROOT_DIR/$dir 
}

dlSubtitles() {
	for f in $1/*
	do
		filename=${f%.*}
		extension=${f##*.}
		if [ "$extension" = "mkv" ] && [ ! -f $filename.srt ]; then
			echo "Dowloading subtitles : $f"
			subliminal -l fr $f
		fi
	done
	
}

makeDir() {
	if [ -d $1 ] ; then 
		return 1 
	fi
	echo "Creating dir : $1" 
	mkdir $1
}

if [ $TR_TORRENT_DIR ] ; then
	DIR=$TR_TORRENT_DIR
else
	DIR=`pwd`
fi
cd $DIR
echo "Working in $DIR"

#if ! cksfv -r -c | grep -q 'Errors Occured'; then
	find . -type f -name '*.rar' | while read i ; do doUnrar "$i" ; done 
#fi
