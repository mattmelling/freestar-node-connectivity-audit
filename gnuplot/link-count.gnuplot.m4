set terminal pngcairo size 480,320
set output 'link-count-NODE.png'
set title 'Node NODE Links'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time

set ylabel 'Links'
set yrange [0:*]

set style line 1 lc rgb '#ff00ff' lt 1 lw 2 pt 7 pi -1 ps 1

set datafile separator ","
plot 'link-count-NODE.csv' using 1:2 title 'Links' with lines ls 1
