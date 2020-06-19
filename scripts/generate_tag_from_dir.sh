#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "$0 root_path"
	exit -1
fi

droot=$(realpath $1)

./sanity_check.sh || exit $?

cd "$droot"
ls | while read uid; do
	iid=$(ls $uid | head -n1 | cut -d_ -f1)

    echo "$uid $(curl -H "cookie: $COOKIES" -Ls "https://www.pixiv.net/ajax/user/$uid/illusts?ids%5B%5D=$iid" | jq -r '.body[].userName' | sed 's#@.*$##g' | sed 's#＠.*$##g')"
done | sort -k1
