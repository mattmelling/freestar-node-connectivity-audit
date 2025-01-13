#!/usr/bin/env bash

while read l; do
    p=(${l//,/ })

    timestamp=${p[0]}
    timestamp=$(($timestamp - ($timestamp % 86400)))

    lnode=${p[1]}

    call=${p[2]}
    rnode=${p[3]}
    status=${p[4]}

    echo "insert into measurements (timestamp, lnode, rnode, callsign, status) values ($timestamp, $lnode, $rnode, '$call', $status) on conflict (timestamp, rnode) do update set status = excluded.status, lnode = excluded.lnode;"
    echo "insert into nodes (id, callsign) values ($rnode, '$call') on conflict (id) do update set callsign = excluded.callsign;"

done < $1
