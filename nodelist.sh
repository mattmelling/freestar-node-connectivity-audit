#!/usr/bin/env bash

format_value () {
    if [ "$1" == "1" ]; then
        echo "<span style=\"color: #00ff00\">Yes</span>"
    else
        echo "<span style=\"color: #ff0000\">No</span>"
    fi
}

sqlite3 nodes.db "select id, callsign from nodes;" > nodes.txt
while read l; do
    p=(${l//|/ })

    id=${p[0]}
    callsign=${p[1]}

    latest=$(echo "select status from measurements where rnode = $id order by timestamp desc limit 1" | sqlite3 nodes.db)

    cat <<EOF
<tr>
  <td><a href="node-$id.html">$callsign</a></td>
  <td>$id</td>
  <td>$(format_value $latest)</td>
</tr>
EOF

done < nodes.txt
rm nodes.txt
