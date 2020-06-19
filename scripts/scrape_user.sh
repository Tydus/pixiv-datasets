#!/bin/bash

#https://www.pixiv.net/users/264932/artworks?p=1


if [ "$1" == "-l" ]; then
    list=1
    shift
fi

if [ $# -lt 1 ]; then
    echo "$0 -l uid|url [args for get_illusts.sh]"
    echo "-l list only"
    exit -1
fi

./sanity_check.sh || exit $?

url=$1; shift

uid="$(echo "$url" | grep -Eo '[0-9]+' | sort -rn | head -n1)"

result=$(curl -H "cookie: $COOKIES" -Ls "https://www.pixiv.net/ajax/user/$uid/profile/all" | jq -r '.body | [.illusts,.manga][] | keys[]' | sort -n)

mkdir -p data/$uid && cd data/$uid

if [ "$list" ]; then
    echo "$result"
    exit 0
else
    echo "$result" | xargs -n10 -P0 ../../get_illusts.sh "$@" "$uid"
fi

rm -f *.jpg.*
