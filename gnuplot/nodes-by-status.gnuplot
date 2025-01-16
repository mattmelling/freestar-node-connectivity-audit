load 'gnuplot/lines.gnuplot'

set terminal pngcairo size 800,600
set output 'dist/nodes-by-status.png'
set title 'Connectivity for all nodes'

set xlabel ''
set timefmt '%Y-%m-%d %H:%M'
set xdata time
set xtics font ",9"

set ylabel 'Count'
set yrange [0:*]

set key left bottom box opaque font ",10"

set datafile separator ","
plot 'nodes-by-status.csv' using 1:2 title 'Accepting connections' with lines ls 1, \
     'nodes-by-status.csv' using 1:3 title 'Not accepting connections' with lines ls 2