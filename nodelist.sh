#!/usr/bin/env bash

format_value () {
    if [ "$1" == "1" ]; then
        echo "<span style=\"color: #00ff00\">Yes</span>"
    else
        echo "<span style=\"color: #ff0000\">No</span>"
    fi
}

sqlite3 nodes.db "select id, callsign, inbound_excluded from nodes order by callsign asc;" > nodes.txt
while read l; do
    p=(${l//|/ })

    id=${p[0]}
    callsign=${p[1]}
    excluded=${p[2]}

    latest=$(echo "select status from measurements where rnode = $id order by timestamp desc limit 1" | sqlite3 nodes.db)

    echo "<tr>"
    echo "  <td><a href=\"node-$id.html\">$callsign</a></td>"
    echo "  <td><a href=\"http://stats.allstarlink.org/stats/$id\">$id</a></td>"

    if [ $latest -eq 0 ]; then
        if [ $excluded -eq 1 ]; then
            echo "  <td><span style=\"color: orange\">Excluded</span>"
        else
            echo "  <td>$(format_value $latest)</td>"
        fi
    else
        echo "  <td>$(format_value $latest)</td>"
    fi
    echo "</tr>"
done < nodes.txt
rm nodes.txt
