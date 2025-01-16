load 'gnuplot/lines.gnuplot'

divert(-1)
define(CALLSIGN, translit(esyscmd(sqlite3 NODEDB "select callsign from nodes where id = NODE_ID;"), `
', `'))
divert(0)dnl
set terminal pngcairo size 800,600
set output 'node-connectivity-NODE_ID.png'
set title 'Connectivity Report for CALLSIGN (NODE_ID)'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time
set xtics font ",9"

set ylabel 'Connectivity'
set yrange [0:1.1]
set ytics 1

set key left bottom box opaque font ",10"

set datafile separator ","
plot 'node-connectivity-NODE_ID.csv' using 1:2 title 'CALLSIGN accepted incoming connection' with linespoints ls 1 pt 7 ps 1.5
