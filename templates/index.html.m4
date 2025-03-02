define(TITLE, FreeSTAR Repeater & Gateway Connectivity Report)
include(templates/header.html)
define(TOTAL_NODES, esyscmd(sqlite3 NODEDB "select count(*) from nodes;"))
define(GOOD_NODES, esyscmd(sqlite3 NODEDB "select count(callsign) from nodes where (select status from measurements where rnode = nodes.id order by timestamp desc limit 1) = 1;"))
define(BAD_NODES, esyscmd(sqlite3 NODEDB "select count(callsign) from nodes where (select status from measurements where rnode = nodes.id order by timestamp desc limit 1) = 0;"))
define(ALL_NODES, esyscmd(cat all_nodelist.html))

<h1>FreeSTAR Repeater & Gateway Connectivity Report</h1>
<div>
  <p>
    This tool has observed <strong>TOTAL_NODES</strong> repeaters and gateways connected to FreeSTAR through nodes
    syscmd(cat freestar_nodelist.html)
  </p>
  <p>Of those, <strong>GOOD_NODES</strong> nodes appear to currently allow incoming connections while <strong>BAD_NODES</strong> do not.</p> 
</div>
<h2>Total Gateway & Repeater Node Connections</h2>
<div style="text-align: center">
     <img src="node-links.png" />
     <img src="node-links-48.png" />
     <img src="nodes-count.png" />
</div>
<h2>Gateway & Repeater Nodes by Status</h2>
<div style="text-align: center">
     <img src="nodes-by-status.png" />
</div>
<div style="margin-top: 20px">
    <table cellpadding="3" cellspacing="3" style="margin: 0 auto">
        <tr>
            <th>Callsign</th>
            <th>Node Number</th>
            <th>Accepts connections</th>
            <th>Keeper</th>
            <th>Location</th>
        </tr>
        syscmd(cat all_nodelist.html)
    </table>
</div>
include(templates/footer.html)
