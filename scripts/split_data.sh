#!/bin/bash

if [ "$# " -ne 4 ]; then
	echo "$0 from train test train_ratio"
	exit -1
fi


dfrom=$(realpath $1)
dtrain=$(realpath $2)
dtest=$(realpath $3)
train_ratio=$4

cd "$dfrom"
ls | while read i; do
	mkdir -p $dtrain/$i $dtest/$i
	pushd $dfrom/$i >/dev/null

	ntrain=$(ls | awk "END{print int(NR*$train_ratio)}")
	#nall=$(ls | wc -l)
	#ntest=$(($nall-$ntrain))

	mv $(ls | sort -R | head -n $ntrain) $dtrain/$i
	mv * $dtest/$i

	popd >/dev/null
    rmdir "$i"
done
