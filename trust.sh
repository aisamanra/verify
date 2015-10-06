#!/bin/sh -e

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
	echo "WARNING: trusting package implicitly" >&2
	echo "In general, this is a BAD IDEA" >&2
	echo "" >&2
	cat ./dat
	cd / && rm -rf $TGT
	exit 0
fi
