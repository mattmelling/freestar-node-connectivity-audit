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
syscmd(cat node-links-lines.gnuplot)
