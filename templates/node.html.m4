define(CALLSIGN, esyscmd(sqlite3 NODEDB "select callsign from nodes where id = NODE_ID;"))
define(TITLE, FreeSTAR Repeater & Gateway Connectivity Report - CALLSIGN (NODE_ID))
include(templates/header.html)
define(NODE_LINK, <a href="http://stats.allstarlink.org/stats/NODE_ID">NODE_ID</a>)
<h1>Connectivity Report for CALLSIGN (NODE_LINK)</h1>
<div style="text-align: center">
  <img src="node-connectivity-NODE_ID.png" />
</div>
<div>
  <p>The chart above shows the results of an automated audit to determine whether <strong>CALLSIGN</strong> (NODE_LINK) can accept incoming connections.</p>
  <p>In order to effectively manage the network, the FreeSTAR admin team occasionally need to move connections from busy nodes to quieter ones. If a repeater or gateway does not accept incoming connections, it is not possible to reconnect it to a quieter node without keeper intervention.</p>
  <p>A point at the <code>1</code> on the chart indicates that this node is able to accept incoming connections, while a <code>0</code> indicates that it does not</p>
  <p>To help us manage the network effectivly, please consider enabling port forwarding so that your node can accept incoming questions. If any technical assistance is required, please reach out to a member of the FreeSTAR admin team.</p>
</div>
include(templates/footer.html)
