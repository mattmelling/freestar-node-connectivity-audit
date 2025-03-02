NODES := 2196 2167 63061 639760
NODEDB := nodes.db

clean:
	rm -rf dist *.csv links-*.txt node-*.json *.png *.html *.gnuplot

#
# Node auditing
#

nodes.db: schema.sql
	sqlite3 $(NODEDB) < schema.sql

audit.csv: $(foreach node,$(NODES),audit-$(node).csv)
	cat $^ >> $@

audit-%.csv: links-%.txt
	./audit-node.sh $* > $@

node-%.json:
	curl -s "https://stats.allstarlink.org/api/stats/$*" > $@

links-%.txt: node-%.json
	jq -r '.stats .data .linkedNodes | .[] | "\(.name),\(.callsign)"' < node-$*.json > $@

# Perform audit
.PHONY: audit
audit: audit.csv
	./update-db.sh audit.csv | sqlite3 nodes.db

#
# Node counts
#

count-%: links-%.txt
	./node-count-links.sh $*

.PHONY: count
count: $(foreach node,$(NODES),count-$(node))

link-count-%.sql: sql/link-count.sql.m4
	m4 -D NODE=$* < sql/link-count.sql.m4 > $@

all-node-link-count.csv: sql/all-node-link-count.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < sql/all-node-link-count.sql > $@

link-count-%.csv: link-count-%.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < link-count-$*.sql > $@

node-links-lines.gnuplot: freestar-nodes-lines.sh
	NODES="$(NODES)" ./freestar-nodes-lines.sh link-count > $@

node-links.gnuplot: gnuplot/node-links.gnuplot.m4 node-links-lines.gnuplot
	m4 < gnuplot/node-links.gnuplot.m4 > $@

dist/node-links.png: node-links.gnuplot all-node-link-count.csv $(foreach node,$(NODES),link-count-$(node).csv) node-links-lines.gnuplot
	mkdir -p dist
	gnuplot < node-links.gnuplot
	mv node-links.png $@

#
# Node counts (48 hours)
#

all-node-link-count-48.csv: sql/all-node-link-count-48.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < sql/all-node-link-count-48.sql > $@

node-links-48.gnuplot: gnuplot/node-links-48.gnuplot.m4 node-links-lines-48.gnuplot
	m4 < gnuplot/node-links-48.gnuplot.m4 > $@

link-count-%-48.sql: sql/link-count-48.sql.m4
	m4 -D NODE=$* < sql/link-count-48.sql.m4 > $@

link-count-%-48.csv: link-count-%-48.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < link-count-$*-48.sql > $@

node-links-lines-48.gnuplot: freestar-nodes-lines.sh
	NODES="$(NODES)" ./freestar-nodes-lines.sh link-count -48 > $@

dist/node-links-48.png: node-links-48.gnuplot all-node-link-count-48.csv $(foreach node,$(NODES),link-count-$(node)-48.csv)
	mkdir -p dist
	gnuplot < node-links-48.gnuplot
	mv node-links.png $@

#
# Top level charts
#

nodes-count.csv: sql/nodes-count.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < sql/nodes-count.sql > $@

nodes-count-%.sql: sql/nodes-count-by-lnode.sql.m4
	m4 -D NODE_ID=$* < sql/nodes-count-by-lnode.sql.m4 > $@

nodes-count-%.csv: nodes-count-%.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < nodes-count-$*.sql > $@

nodes-count-lines.gnuplot: freestar-nodes-lines.sh
	NODES="$(NODES)" ./freestar-nodes-lines.sh nodes-count > $@

nodes-count.gnuplot: gnuplot/nodes-count.gnuplot.m4 nodes-count-lines.gnuplot
	m4 < gnuplot/nodes-count.gnuplot.m4 > nodes-count.gnuplot

dist/nodes-count.png: nodes-count.csv nodes-count.gnuplot $(foreach node,$(NODES),nodes-count-$(node).csv)
	mkdir -p dist
	gnuplot < nodes-count.gnuplot
	mv nodes-count.png $@

nodes-by-status.csv: sql/nodes-by-status.sql $(NODEDB)
	sqlite3 -csv $(NODEDB) < sql/nodes-by-status.sql > $@

dist/nodes-by-status.png: nodes-by-status.csv gnuplot/nodes-by-status.gnuplot
	mkdir -p dist
	gnuplot < gnuplot/nodes-by-status.gnuplot

#
# Node connectivity charts
#

.PRECIOUS: dist/node-connectivity-%.png
dist/node-connectivity-%.png: node-connectivity-%.gnuplot node-connectivity-%.csv
	mkdir -p dist
	gnuplot < node-connectivity-$*.gnuplot
	mv node-connectivity-$*.png $@

node-connectivity-%.csv: node-connectivity-%.sql $(NODEDB)
	sqlite3 -csv nodes.db < node-connectivity-$*.sql > $@

node-connectivity-%.sql: sql/node-connectivity.sql.m4
	m4 -D NODE_ID=$* < sql/node-connectivity.sql.m4 > node-connectivity-$*.sql

node-connectivity-%.gnuplot: gnuplot/node-connectivity.gnuplot.m4
	m4 -D NODEDB="$(NODEDB)" -D NODE_ID=$* < gnuplot/node-connectivity.gnuplot.m4 > $@

#
# Node pages
#

.PHONY: node-pages
node-pages: $(foreach node,$(shell sqlite3 $(NODEDB) "select id from nodes;"),dist/node-$(node).html)

dist/node-%.html: templates/node.html.m4 dist/node-connectivity-%.png
	mkdir -p dist
	m4 -D NODE_ID=$* -D NODEDB="$(NODEDB)" < templates/node.html.m4 > $@

#
# Index page
#

all_nodelist.html: $(NODEDB) nodelist.sh
	./nodelist.sh > $@

freestar_nodelist.html:
	NODES="$(NODES)" ./freestar-nodelist.sh > $@

dist/index.html: dist/nodes-by-status.png dist/nodes-count.png templates/index.html.m4 dist/node-links.png $(NODEDB) all_nodelist.html freestar_nodelist.html dist/node-links-48.png
	m4 -D NODEDB="$(NODEDB)" -D NODES="$(NODES)" < templates/index.html.m4 > $@

.PHONY: report
report: dist/index.html node-pages
