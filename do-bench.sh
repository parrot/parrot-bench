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
    echo -n optimize=`./parrot_config optimize` >>../log.bench
    echo ", gc=`./parrot_config gc_type`" >>../log.bench
else    
    echo -n "cc=" >>../log.bench
    cc --version | head -n1 >>../log.bench
    grep '"optimize"' config_lib.pir >>../log.bench
    grep gc_type config_lib.pir >>../log.bench
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
    echo "" | tee -a ../log.bench
    ;;
Linux)
    echo "loadavg " `cat /proc/loadavg` >> ../log.bench
    old_governor=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
    old_perf=`cat /proc/sys/kernel/perf_event_paranoid`
    if [ x$old_governor != xperformance ]; then
        echo -n "cpufreq scaling_governor: "
        sudo sh -c "echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
    fi
    if [ $old_perf -gt 1 ]; then
        echo -n "perf_event_paranoid: 0"
        sudo sh -c "echo 0 > /proc/sys/kernel/perf_event_paranoid"
    fi
    perf stat -r4 $runbench >/dev/null 2>> ../log.bench
    perf stat -x, $runbench >/dev/null 2>> ../log.bench
    tail -n29 ../log.bench
    if [ x$old_governor = xpowersave ]; then
        echo -n "cpufreq scaling_governor: "
        sudo sh -c "echo $old_governor | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
    fi
    if [ $old_perf -gt 1 ]; then
        echo -n "perf_event_paranoid: $old_perf"
        sudo sh -c "echo $old_perf > /proc/sys/kernel/perf_event_paranoid"
    fi
    ;;
*)
    echo unsupported OS `uname`, perf stat or GNU date +%N
    exit 1
esac
