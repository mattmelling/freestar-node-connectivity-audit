#!/usr/bin/env bash

NODE=$1

curl -s "https://stats.allstarlink.org/api/stats/$NODE" > node.json
jq -r '.stats .data .linkedNodes | .[] | "\(.name),\(.callsign)"' < node.json > links.txt
while read p; do
    pieces=(${p//,/ })
    node=${pieces[0]}
    call=${pieces[1]}
    if [[ "${call:0:2}" == "MB" || "${call:0:2}" == "GB" ]]; then
        echo "$(date +%s),${NODE},${call},$(./test.sh $node)"
    fi
done < links.txt
