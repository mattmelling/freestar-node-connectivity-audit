set terminal pngcairo size 800,600
set output 'dist/nodes-by-status.png'
set title 'Connectivity for all nodes'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time

set ylabel 'Count'
set ytics 1
set yrange [0:*]

set style line 1 lc rgb '#00ff00' lt 1 lw 2 pt 7 pi -1 ps 1.5
set style line 2 lc rgb '#ff0000' lt 1 lw 2 pt 7 pi -1 ps 1.5

set datafile separator ","
plot 'nodes-by-status.csv' using 1:2 title 'Accepting connections' with linespoints ls 1, \
     'nodes-by-status.csv' using 1:3 title 'Not accepting connections' with linespoints ls 2