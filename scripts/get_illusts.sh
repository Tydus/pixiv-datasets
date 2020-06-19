#!/bin/bash

#https://www.pixiv.net/users/264932/artworks?p=1

if [ $# -lt 2 -o $# -gt 101 ]; then
    echo "$0 [-n] uid iid [iid ...]"
    echo "iid should not more than 100"
    exit -1
fi

if [ "$1" == "-l" ]; then
    print_only=1
    shift
fi

if [ "$1" == "-p" ]; then
    preload_only=1
    shift
fi

uid=$1; shift

url=$(echo -n "https://www.pixiv.net/ajax/user/$uid/illusts?"; echo "$@" | tr ' ' '\n' | sed 's@^@ids%5B%5D=@g' | tr '\n' '&')

result=$(curl -H "cookie: $COOKIES" -Ls "$url" | jq -r '.body[].url' | grep -Eo '/img/[0-9/]+_p0' | sed 's@^@https://i.pximg.net/img-master@' | sed 's@$@_master1200.jpg@' | sed 's@i.pximg.net@i-cf.pximg.net@')
if [ "$print_only" ]; then
    echo "$result"
elif [ "$preload_only" ]; then
    echo "$result" | xargs curl -sI >/dev/null
else
    echo "$result" | wget -4 -U TwitterBot -nv -i -
fi
