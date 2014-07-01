#!/bin/sh
# usage: ../parrot-bench/all-bench.sh in a parrot git checkout dir
# runs ../parrot-bench/bench.sh for all RELEASES and stores timings in ../log.bench

echo Warning: will clean all your temp. files!
git clean -dxn
git status -sb
echo Continue?
read x

# debian multiarch fix for icu. not needed with --m=32
#if [ -e /usr/include/x86_64-linux-gnu/unicode -a ! -e /usr/include/unicode ]; then
#    echo sudo ln -s /usr/include/unicode  /usr/include/x86_64-linux-gnu/unicode
#    sudo ln -s /usr/include/unicode  /usr/include/x86_64-linux-gnu/unicode
#fi

date=`date +%Y%m%d`
mv -b ../log.bench ../log.bench-$date

echo "== all-bench " $@ `date` >> ../log.bench
# for now start with 1.7.0 (the 57th release)
for t in `git tag | grep ^RELEASE | tail -n+57` $@; do
    echo bench.sh $t
    ../parrot-bench/bench.sh $t
done

# TODO: data processing and graph creation
data=parrot-bench/parrot-bench-$data.data
egrep "^branch=|seconds time elapsed" ../log.bench | perl -lane'BEGIN{$/="branch="}; print "$F[0]\t$F[1]\t$F[7]"' > $data
