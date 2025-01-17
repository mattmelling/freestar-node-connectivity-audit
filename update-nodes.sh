#!/usr/bin/env bash

sqlite3 nodes.db "select id, callsign from nodes order by callsign asc;" > nodes.txt
while read l; do
    p=(${l//|/ })

    id=${p[0]}
    callsign=${p[1]}
    
    curl -s "https://api-beta.rsgb.online/callsign/$callsign" | jq '.data | first' > repeater-$callsign.json
    keeper=$(jq -r '.keeperCallsign' < repeater-$callsign.json)
    location=$(jq -r '.town' < repeater-$callsign.json)
    location=${location/\'/\'\'}

    if [ "$location" != "null" ]; then
        sqlite3 nodes.db "update nodes set location = '$location' where callsign = '$callsign';"
    fi

    if [ "$keeper" != "null" ]; then
        sqlite3 nodes.db "update nodes set keeper = '$keeper' where callsign = '$callsign';"
    fi

done < nodes.txt
rm nodes.txt

