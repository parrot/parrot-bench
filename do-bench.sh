#!/bin/bash
make -s -j4 parrot_old 2>/dev/null >/dev/null
runbench=../parrot-bench/run-bench_old.sh
if [ ! -e parrot_old ]; then
    make -s -j4 parrot 2>/dev/null >/dev/null
    runbench=../parrot-bench/run-bench.sh
    if [ ! -e parrot ]; then
	echo parrot missing
	exit 1
    fi
fi
if [ ! -e $runbench ]; then
  echo $runbench missing
  exit 1
fi

echo tag=`git describe --long --tags --dirty --always`  >>../log.bench
echo date=`date +"%Y%m%d %X"`  >> ../log.bench
if [ -f parrot_config ]; then
    echo -n "cc=" >>../log.bench
    `./parrot_config cc` --version | head -n1 >>../log.bench
    echo optimize=`./parrot_config optimize` >>../log.bench
else    
    echo -n "cc=" >>../log.bench
    cc --version | head -n1 >>../log.bench
    echo optimize=-O3 >>../log.bench
fi

function bsddate {
    date +%s%N | cut -b1-13
}

case `uname -s` in
Darwin | *bsd*)
    sysctl vm.loadavg >> ../log.bench
    # needs gnu coreutils date. otherwise use
    # perl -MTime::HiRes -E'say Time::HiRes::gettimeofday()'
    start=`date +%s%N | cut -b1-13`
    sum=0
    sumsq=0
    for i in `seq 4`; do
	$runbench >/dev/null 2>> ../log.bench
	end=`date +%s%N | cut -b1-13`
	t=$(($end - $start))
	sum=$(($sum + $t))
	sumsq=$(($sumsq + ($t * $t)))
	echo -n "$t "
	start=$end
    done
    avg=$((sum / 4))
    stddev=`echo "sqrt ($sumsq / 4 - ($avg * $avg))" | bc`
    #perl -MMath::NumberCruncher -E"say Math::NumberCruncher::StandardDeviation([qw($t[1] $t[2] $t[3] $t[4])],2)"
    echo avg: $avg "ms /" $stddev | tee -a ../log.bench
    ;;
Linux)
    echo "loadavg " `cat /proc/loadavg` >> ../log.bench
    perf stat -r4 $runbench >/dev/null 2>> ../log.bench
    perf stat -x, $runbench >/dev/null 2>> ../log.bench
    tail -n29 ../log.bench
    ;;
*)
    echo unsupported OS `uname`, perf stat or GNU date +%N
    exit 1
esac
