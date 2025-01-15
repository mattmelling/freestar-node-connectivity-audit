set terminal pngcairo size 640,480
set output 'dist/nodes-count.png'
set title 'Repeater and Gateway Node Links'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time

set ylabel 'Count'
set yrange [0:*]

set style line 1 lc rgb '#0000ff' lt 1 lw 2 pt 7 pi -1 ps 1

set datafile separator ","
plot 'nodes-count.csv' using 1:2 title 'Count' with lines ls 1