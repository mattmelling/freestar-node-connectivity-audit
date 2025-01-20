#!/usr/bin/env bash

format_value () {
    if [ "$1" == "1" ]; then
        echo "<span style=\"color: #00ff00\">Yes</span>"
    else
        echo "<span style=\"color: #ff0000\">No</span>"
    fi
}

format_avg() {
    echo "<span style=\"color: #cccccc\">(${1}%)</span>"
}

qrz_link () {
    echo "<a href=\"https://www.qrz.com/db/$1\">$1</a>"
}

sqlite3 nodes.db "select id, callsign, inbound_excluded, location, keeper from nodes order by callsign asc;" > nodes.txt
while read l; do
    IFS="|" read -r -a p <<< "$l"

    id="${p[0]}"
    callsign="${p[1]}"
    excluded="${p[2]}"
    location="${p[3]}"
    keeper="${p[4]}"

    result=$(echo "select case when avg(status) > 0 then 1 else 0 end as st, avg(status) as st_avg from measurements where rnode = $id order by timestamp desc limit 5" | sqlite3 nodes.db)
    IFS="|" read -r -a a <<< "$result"
    latest="${a[0]}"
    avg="$(echo "a = ${a[1]} * 100; scale=2; a * 1" | bc)"
    avg="$(printf %.0f $avg)"

    echo "<tr>"
    echo "  <td><a href=\"node-$id.html\">$callsign</a></td>"
    echo "  <td><a href=\"http://stats.allstarlink.org/stats/$id\">$id</a></td>"

    if [ $latest -eq 0 ]; then
        if [ $excluded -eq 1 ]; then
            echo "  <td><span style=\"color: orange\">Excluded</span>"
        else
            echo "  <td>$(format_value $latest) $(format_avg $avg)</td>"
        fi
    else
        echo "  <td>$(format_value $latest) $(format_avg $avg)</td>"
    fi
    echo "  <td>$(qrz_link $keeper)</td>"
    echo "  <td>$location</td>"
    echo "</tr>"
done < nodes.txt
rm nodes.txt
