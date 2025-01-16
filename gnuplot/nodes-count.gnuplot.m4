load 'gnuplot/lines.gnuplot'

set terminal pngcairo size 640,480
set output 'nodes-count.png'
set title 'Repeater and Gateway Node Links'

set xlabel ''
set timefmt '%Y-%m-%d %H:%M'
set xdata time
set xtics font ",9"

set ylabel 'Count'
set yrange [0:*]

set key left bottom box opaque font ",10"

set datafile separator ","
plot 'nodes-count.csv' using 1:2 title 'Count' with lines ls 1, \
syscmd(cat nodes-count-lines.gnuplot)
