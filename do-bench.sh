#!/bin/sh
make -s -j4 test_prep

echo tag=`git describe --long --tags --dirty --always`  >>../log.bench
echo -n "cc=" >>../log.bench
`./parrot_config cc` --version | head -n1 >>../log.bench
echo optimize=`./parrot_config optimize` >>../log.bench

echo "loadavg " `cat /proc/loadavg` >> ../log.bench
perf stat -r4 ../run-bench.sh >/dev/null 2>> ../log.bench
perf stat -x, ../run-bench.sh >/dev/null 2>> ../log.bench
tail -n29 ../log.bench
