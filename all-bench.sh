#!/bin/sh
# usage: ../parrot-bench/all-bench.sh in a parrot git checkout dir
# runs ../parrot-bench/bench.sh for all RELEASES and stores timings in ../log.bench

echo Warning: will clean all your temp. files!
git clean -dxn
git status -sb
echo Continue?
read x

# debian multiarch fix for icu. not needed with --m=32 or parrot >= 6.4.0
#if [ -e /usr/include/x86_64-linux-gnu/unicode -a ! -e /usr/include/unicode ]; then
#    echo sudo ln -s /usr/include/x86_64-linux-gnu/unicode /usr/include/unicode
#    sudo ln -s /usr/include/x86_64-linux-gnu/unicode /usr/include/unicode
#fi

date=`date +%Y%m%d`
mv -b ../log.bench ../log.bench-$date

echo "== all-bench " $@ `date` >> ../log.bench
# for now start with 1.7.0 (the 57th release)
for t in `git tag | grep ^RELEASE | tail -n+57` $@; do
    echo bench.sh $t
    ../parrot-bench/bench.sh $t
done

# data processing and graph creation for gnuplot
log=../parrot-bench/log.bench-$date
cp ../log.bench $log
data=../parrot-bench/parrot-bench-$date.data
echo "release            secs         error(%)" > $data
egrep "^branch=|seconds time elapsed" $log | \
    perl -lane'BEGIN{$/="branch="}; $F[0]=~s/RELEASE_//; $F[0]=~s|rurban/|0|; print "$F[0]\t$F[1]\t$F[7]" if $F[1]' >> $data
if [ ! -e ../parrot-bench/parrot-bench-$date.plot ]; then
    sed -e"s,-template,-$date," < ../parrot-bench/parrot-bench-template.plot > ../parrot-bench/parrot-bench-$date.plot
fi
cd ../parrot-bench
gnuplot parrot-bench-$date.plot
cd -
