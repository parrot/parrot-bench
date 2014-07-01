# -*- gnuplot -*-
set terminal pngcairo transparent enhanced font "Arial,11" size 800, 520
set output 'parrot-bench-m32-20140631.png'
set grid nopolar
set style data linespoints
set xtics rotate by -90 font "Arial,9"
set format y "%0.1f"
set ytics (14, 13.5, 13, 12.5, 12, 11.5, 11, 10.5, 10, 9.5, 9) rotate by 0
set title "parrot performance (seconds)"
set xlabel "Releases"
set ylabel "secs"
set grid y
set yr [ 9 : 14 ] noreverse nowriteback
set label "amd64 -m32 / https://github.com/parrot/parrot-bench" at graph 0.01, 0.06
set style fill transparent solid 0.2

#plot 'parrot-bench-template.data' 0:1:2 with errorbars, \
#  '' using 0:2 title column(2) with lines

plot 'parrot-bench-m32-20140631.data' using 1:xtic(1) notitle, \
  '' using 0:2 title column(2) with lines lt 3, \
  '' using 0:($2-($2/100*$3)) title column(3) with lines lt 2, \
  '' using 0:($2+($2/100*$3)) title column(3) with lines lt 2, \
  '' using 0:($2-($2/100*$3)):($2+($2/100*$3)) title column(3) with filledcurves