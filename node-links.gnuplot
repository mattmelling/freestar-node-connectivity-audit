load 'gnuplot/lines.gnuplot'

set terminal pngcairo size 640,480
set output 'node-links.png'
set title 'Node Links'

set xlabel ''
set timefmt '%Y-%m-%d %H:%M'
set xdata time
set xtics font ",9"

set ylabel 'Count'
set yrange [0:*]
show ylabel

set key left bottom box opaque font ",10"

set datafile separator ","
plot 'all-node-link-count.csv' using 1:2 title 'Total' with lines ls 1, \
'link-count-2196.csv' using 1:2 title '2196' with lines ls 2, \
'link-count-2167.csv' using 1:2 title '2167' with lines ls 3, \
'link-count-63061.csv' using 1:2 title '63061' with lines ls 4, \
'link-count-639760.csv' using 1:2 title '639760' with lines ls 5, 

