#!/bin/bash

if [ "$# " -ne 3 ]; then
	echo "$0 from to train_ratio"
	exit -1
fi

dfrom=$(realpath $1)
dto=$(realpath $2)
train_ratio=$3

dtrain="$dto/train"
dtest="$dto/test"
mkdir -p "$dtrain" "$dtest"

cd "$dfrom"
ls | while read i; do
    sort -R $i > "$i-sorted"

    ntrain=$(wc -l "$i-sorted" | awk "{print       int(\$1 * $train_ratio)}")
    ntest=$( wc -l "$i-sorted" | awk "{print \$1 - int(\$1 * $train_ratio)}")

	cat $i | head -n $ntrain > "$dtrain/$i"
	cat $i | tail -n $ntest  > "$dtest/$i"

    rm "$i-sorted"
done
