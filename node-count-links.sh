#!/usr/bin/env bash

NODE=$1
NODEDB=nodes.db
COUNT=$(jq -r '.stats .data .linkedNodes | length' < node-$NODE.json)
timestamp=$(date +%s)
timestamp=$(($timestamp - ($timestamp % 3600)))
cat <<EOF | sqlite3 $NODEDB
    insert into node_count (
        timestamp,
        node,
        link_count
    ) values (
        $timestamp,
        $NODE,
        $COUNT
    )
    on conflict (timestamp, node)
    do update set link_count = excluded.link_count;
EOF
