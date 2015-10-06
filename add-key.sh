#!/bin/sh -e

TRUSTDIR=${TRUSTDIR-"$HOME/.trusted"}
mkdir -p $TRUSTDIR

if [ $# -lt 1 ]; then
	echo "Usage: $0 pubkey [...]" >&2
	exit 111
fi

RET=0
for k in $@; do
	case $k in
		http://*)
			( cd $TRUSTDIR && curl -s -O $k 2>/dev/null ) || (
				echo "Unable to add ${k}" >&2
				RET=111
			)
			;;
		https://*)
			( cd $TRUSTDIR && curl -s -O $k 2>/dev/null ) || (
				echo "Unable to add ${k}" >&2
				RET=111
			)
			;;
		*://*)
			echo "Unrecognized protocol: $(echo $k | sed 's/:\/\/.*//')" >&2
			echo "Unable to add ${k}" >&2
			RET=111
			;;
		*)
			if [ -e $k ]; then
				cp $k ~/.trusted/. || (
					echo "Error copying ${k}" >&2
					echo "Unable to add ${k}" >&2
					RET=111
				)
			else
				echo "No file $k found." >&2
				echo "Unable to add ${k}" >&2
				RET=111
			fi
	esac
done
exit ${RET}
