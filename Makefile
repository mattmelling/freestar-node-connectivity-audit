NODES := 2196 2167 63061 639760
NODEDB := nodes.db

clean:
	rm -rf dist *.csv links-*.txt node-*.json *.png

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

dist/all-node-link-count.png: gnuplot/all-node-link-count.gnuplot all-node-link-count.csv
	mkdir -p dist
	gnuplot < gnuplot/all-node-link-count.gnuplot
	mv all-node-link-count.png $@

link-count-%.gnuplot: gnuplot/link-count.gnuplot.m4
	m4 -D NODE=$* < gnuplot/link-count.gnuplot.m4 > $@

dist/link-count-%.png: link-count-%.gnuplot link-count-%.csv
	mkdir -p dist
	gnuplot < link-count-$*.gnuplot
	mv link-count-$*.png $@

#
# Top level charts
#

nodes-count.csv: sql/nodes-count.sql
	sqlite3 -csv $(NODEDB) < $^ > $@

dist/nodes-count.png: nodes-count.csv gnuplot/nodes-count.gnuplot
	mkdir -p dist && gnuplot < gnuplot/nodes-count.gnuplot

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

all_nodelist.html:
	./nodelist.sh > $@

freestar_nodelist.html:
	NODES="$(NODES)" ./freestar-nodelist.html > $@

dist/index.html: dist/nodes-by-status.png dist/nodes-count.png templates/index.html.m4 dist/all-node-link-count.png $(foreach node,$(NODES),dist/link-count-$(node).png) $(NODEDB) all_nodelist.html freestar_nodelist.html
	m4 -D NODEDB="$(NODEDB)" -D NODES="$(NODES)" < templates/index.html.m4 > $@

.PHONY: report
report: dist/index.html node-pages
