#!/bin/bash

if [ ! "$COOKIES" ]; then
    echo "Cookies is not set." >&2
    exit -1
fi

result=$(curl -H "cookie: $COOKIES" -Ls 'https://www.pixiv.net/ajax/user/extra' | jq -r .error)

if [ "$result" != "false" ]; then
    echo "Login error." >&2
    exit -1
fi
