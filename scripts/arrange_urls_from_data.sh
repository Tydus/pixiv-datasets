#!/bin/bash

if [ "$# " -lt 2 ]; then
    echo "$0 url_dir train [test]"
    exit -1
fi


url_dir=$(realpath $1)                               # /path/to/url
shift

for split in $@; do
    dest_dir=$url_dir/$split                         # /path/to/url/train256n
    mkdir $url_dir/$split || exit

    split_dir=$(realpath $split)                     # /path/from/train256n

    pushd $split_dir
    ls | while read d; do                            # 26644
        ls "$d" | while read fn; do                  # 123456_p0_master1200.jpg
            result=$(grep "$fn\$" "$url_dir/$d.txt") # i-cf.pximg.net/xxxx/xxx.jpg
            if [ "$result" ]; then
                echo "$result" >> "$dest_dir/$d.txt" # /path/to/url/train256n/26644.txt
            else
                echo "Warning: no match for $d/$fn" >&2
            fi
        done
    done
    popd

done

