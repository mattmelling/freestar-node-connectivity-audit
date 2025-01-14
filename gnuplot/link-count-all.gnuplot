set terminal pngcairo size 640,480
set output 'link-count-all.png'
set title 'All Node Links'

set xlabel 'Time'
set timefmt '%Y-%m-%d %H:%M:%S'
set xdata time

set ylabel 'Links'
set yrange [0:*]

set style line 1 lc rgb '#ff00ff' lt 1 lw 2 pt 7 pi -1 ps 1.5

set datafile separator ","
plot 'link-count-all.csv' using 1:2 title 'Links' with linespoints ls 1
