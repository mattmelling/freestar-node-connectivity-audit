#!/usr/bin/env bash

NODE=$1
NODEDB=${NODEDB:-nodes.db}
SUCCESS_TIMEOUT=$(( 86400 * 1 ))

maybe_audit_node() {
    # Only audit nodes if we haven't seen a successful result for SUCCESS_TIMEOUT
    last_successful_measurement=$(sqlite3 $NODEDB "select timestamp from measurements where status = 1 and rnode = $node order by timestamp desc limit 1")
    timestamp=$(date +%s)
    cutoff=$(( $last_successful_measurement + $SUCCESS_TIMEOUT ))

    if [ $cutoff -lt $timestamp ]; then
        echo "$(date +%s),${NODE},${call},$(./test.sh $node)"
    fi
}

while read p; do
    pieces=(${p//,/ })
    node=${pieces[0]}
    call=${pieces[1]}
    if [[ "${call:0:2}" == "MB" || "${call:0:2}" == "GB" ]]; then
        maybe_audit_node $node
    fi
done < links-$NODE.txt
