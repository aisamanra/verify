#!/bin/sh -e

if [ $# -lt 3 ]; then
	echo "Usage: $0 private-key payload output" >&2
	exit 111
fi

KEY="$1"
DAT="$2"
TGT="$(cd $(dirname $3); pwd)/$(basename $3)"

if [ ! -e ${KEY} ]; then
	echo "Private key ${KEY} does not exist." >&2
	exit 111
fi
if [ ! -e ${DAT} ]; then
	echo "Payload file ${DAT} does not exist." >&2
	exit 111
fi
if [ -e ${TGT} ]; then
	echo "Target package ${TGT} exists and will be overwritten." >&2
fi

TMP=`mktemp -d`

signify -S -s ${KEY} -m ${DAT} -x ${TMP}/sig ||
	rm -rf ${TMP}
cp ${DAT} ${TMP}/dat
(
	cd ${TMP}
	tar -c -f ${TGT} sig dat
)
rm -rf ${TMP}
