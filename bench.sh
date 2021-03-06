#!/bin/sh
#old runs parrot_old, which is faster to make
runbench=../parrot-bench/run-bench_old.sh
if [ ! -e $runbench ]; then
  echo $runbench missing
  exit 1
fi
if [ -n $1 ]; then
  git clean -dxf 2>&1 >/dev/null
  git checkout $1 2>&1 >/dev/null
else
  make -j4 -s clean archclean 2>&1 >/dev/null
fi

optimize="-O2"
if true; then
    optimize="-O3"
fi

# icu patch in all-bench.sh
# todo md2: patch away or --without-crypto?
#if < 1.8.0 and x86_64 use --m=32
baseopt="--optimize=\"$optimize\""
set -x
perl Configure.pl $baseopt --without-libffi --without-icu --without-crypto --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu --without-crypto --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu --without-crypto 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu --without-libffi --without-opengl 2>&1 >/dev/null \
    || perl Configure.pl $baseopt --without-icu 2>&1 >/dev/null \
    || perl Configure.pl $baseopt 2>&1 >/dev/null
set +x
if [ $(perl -e'exit 1 if `cat VERSION` gt "1.7.0"') ]; then
    echo patch NUM_REGISTERS 40
    sed -i -e's,#define NUM_REGISTERS 32,#define NUM_REGISTERS 40,' include/parrot/parrot.h
fi

config_lib=config_lib.pir
if [ -e config_lib.pasm ]; then config_lib=config_lib.pasm; fi

# more aggressive optimizations, only safe to use for newer parrots
if true; then
    # now this is highly system dependent, to get better defaults (cc=gcc-4.9 debian)
    #sed -i 's/-shared -O2/-shared -Wl,-O1/' Makefile $config_lib lib/Parrot/Config/Generated.pm
    #sed -i 's|-fstack-protector -L/usr/local/lib|-fstack-protector -L/usr/local/lib -Wl,--as-needed -Wl,-z,relro -Wl,-z,now|' Makefile $config_lib lib/Parrot/Config/Generated.pm
    #sed -i 's|-Wl,-rpath,/usr/local/lib/perl5/5.14.4/x86_64-linux/CORE||' Makefile $config_lib lib/Parrot/Config/Generated.pm
    #sed -i 's,-O2,-O3,' $config_lib lib/Parrot/Config/Generated.pm
    #sed -i 's,-O2 -f,-O3 -f,' Makefile
    #sed -i 's,-O2 \$,-O3 \$,' Makefile

    # not affecting bench, only build-times:
    sed -i 's,$(PERL) -MExtUtils::Command -e ,,' Makefile
    sed -i 's,= rm_f,= rm -f,; s,= rm_rf,= rm -rf,; s,= mkpath,= mkdir -p,' Makefile
fi

# config.fpmc fallback only needed < 1.8
# parrot_old builds much faster, since 3.?
make -j4 -s parrot_old 2>/dev/null >/dev/null \
  || (rm runtime/parrot/include/config.fpmc; make -j4 -s parrot parrot_config) 2>/dev/null >/dev/null
parrot=parrot_old
if [ ! -e parrot_old ]; then
    echo no parrot_old, made parrot instead
    parrot=parrot
    runbench=../parrot-bench/run-bench.sh
fi

echo >>../log.bench
echo branch=$1 >>../log.bench

../parrot-bench/do-bench.sh
