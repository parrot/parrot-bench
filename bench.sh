#!/bin/sh
if [ -n $1 ]; then
  git clean -dxf 2>&1 >/dev/null
  git checkout $1 2>&1 >/dev/null
else
  make -s clean archclean 2>&1 >/dev/null
fi
perl Configure.pl --optimize --without-crypto --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl --optimize --without-crypto 2>&1 >/dev/null \
    || perl Configure.pl --optimize --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl --optimize  2>&1 >/dev/null
make -j4 -s 2>/dev/null >/dev/null \
  || (rm runtime/parrot/include/config.fpmc; make -s parrot) 2>/dev/null >/dev/null
make -s test_prep 2>/dev/null >/dev/null

echo $1 >> ../log.bench
if [ -e parrot ]; then
    echo "loadavg " `cat /proc/loadavg` >> ../log.bench
    perf stat -r4 ../run-bench.sh >/dev/null 2>> ../log.bench
    perf stat -x, ../run-bench.sh >/dev/null 2>> ../log.bench
    tail -n4 ../log.bench
else
    echo 'no parrot'
fi

