set terminal pngcairo size 800,600
set output 'dist/nodes-count.png'
set title 'Nodes count'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time

set ylabel 'Count'
set ytics 1
set yrange [0:*]

set style line 1 lc rgb '#0000ff' lt 1 lw 2 pt 7 pi -1 ps 1.5

set datafile separator ","
plot 'nodes-count.csv' using 1:2 title 'Count' with linespoints ls 1