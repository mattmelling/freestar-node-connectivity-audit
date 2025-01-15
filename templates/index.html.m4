include(templates/header.html)
define(TOTAL_NODES, esyscmd(sqlite3 NODEDB "select count(*) from nodes;"))
define(GOOD_NODES, esyscmd(sqlite3 NODEDB "select count(callsign) from nodes where (select status from measurements where rnode = nodes.id order by timestamp desc limit 1) = 1;"))
define(BAD_NODES, esyscmd(sqlite3 NODEDB "select count(callsign) from nodes where (select status from measurements where rnode = nodes.id order by timestamp desc limit 1) = 0;"))
define(ALL_NODES, esyscmd(./nodelist.sh))

<h1>FreeSTAR Repeater & Gateway Connectivity Report</h1>
<div>
  <p>This tool has observed <strong>TOTAL_NODES</strong> repeaters and gateways connected to FreeSTAR through nodes <strong>NODES</strong></p>
  <p>Of those, <strong>GOOD_NODES</strong> nodes appear to currently allow incoming connections while <strong>BAD_NODES</strong> do not.</p> 
</div>
<h2>Total Gateway & Repeater Node Connections</h2>
<div style="text-align: center">
     <img src="all-node-link-count.png" />
     <img src="nodes-count.png" />
</div>
<div style="text-align: center">
     <img src="link-count-2167.png" />
     <img src="link-count-2196.png" />
     <img src="link-count-63061.png" />
</div>
<h2>Gateway & Repeater Nodes by Status</h2>
<div style="text-align: center">
     <img src="nodes-by-status.png" />
</div>
<table cellpadding="3" cellspacing="3">
  <tr>
    <th>Callsign</th>
    <th>Node Number</th>
    <th>Accepts connections</th>
  </tr>
  ALL_NODES
</table>
include(templates/footer.html)
