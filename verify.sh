#!/bin/sh -e

TRUSTDIR=${TRUSTDIR-"$HOME/.trusted"}

if [ ! "$(which signify)" ]; then
	echo "Unable to find signify utility" >&2
	exit 111
fi

if [ ! -e $TRUSTDIR ]; then mkdir $TRUSTDIR; fi

if [ ! "$(ls -A $TRUSTDIR)" ]; then
	echo "No trusted keys in $TRUSTDIR" >&2
	exit 111
fi

TGT=`mktemp -d`
cd $TGT
tar -xf - || (
	echo "Malformed data: not a tar archive" >&2
	cd .. && rm -rf $TGT
	exit 111
)
if [ ! -e ./sig ]; then
	echo "Malformed data: missing signature" >&2
	cd .. && rm -rf $TGT
	exit 111
elif [ ! -e ./dat ]; then
	echo "Malformed data: missing payload" >&2
	cd .. && rm -rf $TGT
	exit 111
else
	for pub in $TRUSTDIR/*; do
		if signify -Vq -p $pub -m ./dat -x ./sig; then
			cat ./dat
			cd / && rm -rf $TGT
			exit 0
		fi
	done
	echo "Unable to verify file" >&2
	cd .. && rm -rf $TGT
	exit 111
fi
