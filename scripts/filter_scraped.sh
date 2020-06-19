#!/bin/bash


diff <(cut -d' ' -f1 | sort -n | uniq ) <(ls */* -d | cut -d/ -f2 | sort -n | uniq) | awk '/^</{print $2}'
