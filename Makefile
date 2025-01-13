NODES := 2196 2167 63061
NODEDB := nodes.db

clean:
	rm -rf *.csv *.json links.txt nodes.txt dist

#
# Node auditing
#

nodes.db: schema.sql
	sqlite3 $(NODEDB) < schema.sql

audit.csv: $(foreach node,$(NODES),audit-$(node).csv) # hubs.csv
	cat $^ >> $@

audit-%.csv:
	./audit-node.sh $* > $@

# Perform audit
audit: audit.csv
	./update-db.sh audit.csv | sqlite3 nodes.db

#
# Top level charts
#

nodes-count.csv: sql/nodes-count.sql
	sqlite3 -csv $(NODEDB) < $^ > $@

dist/nodes-count.png: nodes-count.csv gnuplot/nodes-count.gnuplot
	mkdir -p dist && gnuplot < gnuplot/nodes-count.gnuplot

nodes-by-status.csv: sql/nodes-by-status.sql
	sqlite3 -csv $(NODEDB) < $^ > $@

dist/nodes-by-status.png: nodes-by-status.csv gnuplot/nodes-by-status.gnuplot
	mkdir -p dist && gnuplot < gnuplot/nodes-by-status.gnuplot

#
# Node connectivity charts
#

dist/node-connectivity-%.png: node-connectivity-%.gnuplot node-connectivity-%.csv
	mkdir -p dist && gnuplot < node-connectivity-$*.gnuplot && mv node-connectivity-$*.png $@

node-connectivity-%.csv: node-connectivity-%.sql
	sqlite3 -csv nodes.db < node-connectivity-$*.sql > $@

node-connectivity-%.sql: sql/node-connectivity.sql.m4
	m4 -D NODE_ID=$* < sql/node-connectivity.sql.m4 > node-connectivity-$*.sql

node-connectivity-%.gnuplot: gnuplot/node-connectivity.gnuplot.m4
	m4 -D CALLSIGN=$(shell sqlite3 $(NODEDB) "select callsign from nodes where id = $*;") \
	   -D NODE_ID=$* \
	< gnuplot/node-connectivity.gnuplot.m4 > $@

#
# Node pages
#

node-pages: $(foreach node,$(shell sqlite3 $(NODEDB) "select id from nodes;"),dist/node-$(node).html)

dist/node-%.html: templates/node.html.m4 dist/node-connectivity-%.png
	m4 -D CALLSIGN=$(shell sqlite3 $(NODEDB) "select callsign from nodes where id = $*;") \
	   -D NODE_ID=$* \
	< templates/node.html.m4 > $@

#
# Index page
#

dist/index.html: dist/nodes-by-status.png dist/nodes-count.png templates/index.html.m4
	m4 -D NODEDB=nodes.db < templates/index.html.m4 > $@

report: dist/index.html node-pages
