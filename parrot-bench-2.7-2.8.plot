# -*- gnuplot -*-
set terminal pngcairo transparent enhanced font "Arial,11" size 800, 520
set output 'parrot-bench-2.7-2.8.png'
set grid nopolar
set style data linespoints
set xtics rotate by -90 font "Arial,9"
set format y "%0.1f"
#set ytics (12, 11.5, 11, 10.5, 10, 9.5, 9, 8.5, 8) rotate by 0
set title "parrot performance (seconds)"
set xlabel "Commits"
set ylabel "secs"
set grid y
#set yr [ 7.5 : 12.5 ] noreverse nowriteback
set yr [ 33.5 : 35.5 ] noreverse nowriteback
set label "from Release 2.8 to 2.7 https://github.com/parrot/parrot-bench" at graph 0.01, 0.05
set style fill transparent solid 0.2

#plot 'parrot-bench-template.data' 0:1:2 with errorbars, \
#  '' using 0:2 title column(2) with lines

plot 'parrot-bench-2.7-2.8.data.1' using 1:xtic(1) notitle, \
  'parrot-bench-2.7-2.8.data.1' using 0:2 title "secs" with lines lt 3, \
  'parrot-bench-2.7-2.8.data.1' using 0:($2-($2/100*$3)) title "" with lines lt 2, \
  'parrot-bench-2.7-2.8.data.1' using 0:($2+($2/100*$3)) title "" with lines lt 2, \
  'parrot-bench-2.7-2.8.data.1' using 0:($2-($2/100*$3)):($2+($2/100*$3)) title "error(%)" with filledcurves