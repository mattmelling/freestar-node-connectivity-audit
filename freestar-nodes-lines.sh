#!/usr/bin/env bash

prefix=$1

list_nodes () {
    s=2
    nodes=($NODES)
    for n in "${nodes[@]}"; do
        echo "'$prefix-$n.csv' using 1:2 title '$n' with lines ls $s, \\"
        s=$((s + 1))
    done
}

o=$(list_nodes)
echo "${o::-1}"
