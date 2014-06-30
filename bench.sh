#!/bin/sh
if [ ! -e ../parrot-bench/run-bench.sh ]; then
  echo ../parrot-bench/run-bench.sh missing
  exit 1
fi
if [ -n $1 ]; then
  git clean -dxf 2>&1 >/dev/null
  git checkout $1 2>&1 >/dev/null
else
  make -s clean archclean 2>&1 >/dev/null
fi

# icu patch in all-bench.sh
# todo md2: patch away or --without-crypto?
#if < 1.8.0 and x86_64 use --m=32
baseopt="--m=32 --optimize"

perl Configure.pl $baseopt --without-libffi --without-icu --without-crypto --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu --without-crypto --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu --without-crypto 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu --without-libffi --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu 2>&1 >/dev/null \
    || perl Configure.pl $baseopt 2>&1 >/dev/null

if [ $(perl -e'exit 1 if `cat VERSION` gt "1.7.0"') ]; then
    echo patch NUM_REGISTERS 40
    sed -i -e's,#define NUM_REGISTERS 32,#define NUM_REGISTERS 40,' include/parrot/parrot.h
fi

config_lib=config_lib.pir
if [ -e config_lib.pasm ]; then config_lib=config_lib.pasm; fi

# more aggressive optimizations, only safe to use for newer parrots
if [ /bin/false ]; then
    # now this is highly system dependent, to get better defaults (cc=gcc-4.9 debian)
    sed -i 's/-shared -O2/-shared -Wl,-O1/' Makefile $config_lib lib/Parrot/Config/Generated.pm
    sed -i 's|-fstack-protector -L/usr/local/lib|-fstack-protector -L/usr/local/lib -Wl,--as-needed -Wl,-z,relro -Wl,-z,now|' Makefile $config_lib lib/Parrot/Config/Generated.pm
    sed -i 's|-Wl,-rpath,/usr/local/lib/perl5/5.14.4/x86_64-linux/CORE||' Makefile $config_lib lib/Parrot/Config/Generated.pm
    sed -i 's,-O2,-O3,' config_lib.pir lib/Parrot/Config/Generated.pm
    sed -i 's,-O2 -f,-O3 -f,' Makefile
    sed -i 's,-O2 \$,-O3 \$,' Makefile
    sed -i 's,$(PERL) -MExtUtils::Command -e ,,' Makefile
    sed -i 's,= rm_f,= rm -f,; s,= rm_rf,= rm -rf,; s,= mkpath,= mkdir -p,' Makefile
fi

make -j4 -s 2>/dev/null >/dev/null \
  || (rm runtime/parrot/include/config.fpmc; make -s parrot) 2>/dev/null >/dev/null
make -s test_prep 2>/dev/null >/dev/null

echo $1 >>../log.bench
git describe --long --tags --dirty --always  >> ../log.bench
echo -n cc= >>../log.bench
`./parrot_config cc` --version | head -n1 >>../log.bench
echo -n optimize=
`./parrot_config optimize` >>../log.bench

if [ -e parrot ]; then
    echo "loadavg " `cat /proc/loadavg` >> ../log.bench
    perf stat -r4 ../parrot-bench/run-bench.sh >/dev/null 2>> ../log.bench
    perf stat -x, ../parrot-bench/run-bench.sh >/dev/null 2>> ../log.bench
    tail -n29 ../log.bench
else
    echo 'no parrot'
fi

