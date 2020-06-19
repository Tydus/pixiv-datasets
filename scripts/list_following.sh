#!/bin/bash

# https://www.pixiv.net/ajax/user/9871222/following?offset=0&limit=100&rest=show&tag=

if [ "$#" -ne 1 ]; then
    echo "$0 uid"
    exit -1
fi

uid=$1
./sanity_check.sh || exit $?

for ((i=0;i<10000;i+=100)); do
    url="https://www.pixiv.net/ajax/user/$uid/following?offset=$i&limit=100&rest=show&tag="

    result="$(curl -H "cookie: $COOKIES" -Ls "$url" | jq -r '.body.users[] | [.userId, .userName] | @tsv'| tr '\t' ' ' | sed 's#@.*$##g' | sed 's#＠.*$##g')"
    [ ! "$result" ] && exit 0
    echo "$result"
done
