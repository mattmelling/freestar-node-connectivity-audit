set terminal pngcairo size 640,480
set output 'all-node-link-count.png'
set title 'All Node Links'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time

set ylabel 'Links'
set yrange [0:*]

set style line 1 lc rgb '#ff00ff' lt 1 lw 2 pt 7 pi -1 ps 1

set datafile separator ","
plot 'all-node-link-count.csv' using 1:2 title 'Links' with lines ls 1
