#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "$0 limit folder"
    exit -1
fi

limit=$1
folder=$2

cd "$folder"
total=$(ls | wc -l)
[ $total -gt $limit ] && ls | sort -n | head -n$((total-limit)) | xargs rm
