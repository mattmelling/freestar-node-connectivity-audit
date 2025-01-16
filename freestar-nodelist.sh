#!/usr/bin/env bash

node_link () {
    echo "http://stats.allstarlink.org/stats/$1"
}

list_nodes () {
    nodes=($NODES)
    for n in "${nodes[@]}"; do
        echo "<strong><a href=\"$(node_link $n)\">$n</a></strong>,"
    done
}

o=$(list_nodes)
echo "${o::-1}"
