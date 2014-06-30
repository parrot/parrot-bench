#!/bin/sh
# usage: ../parrot-bench/all-bench.sh
# runs ../parrot-bench/bench.sh for all RELEASES and stores timings in ../log.bench

echo Warning: will clean all your temp. files!
git clean -dxn
echo Continue?
read x

# debian multiarch fix for icu. not needed with --m=32
#if [ -e /usr/include/x86_64-linux-gnu/unicode -a ! -e /usr/include/unicode ]; then
#    echo sudo ln -s /usr/include/unicode  /usr/include/x86_64-linux-gnu/unicode
#    sudo ln -s /usr/include/unicode  /usr/include/x86_64-linux-gnu/unicode
#fi

for t in `git tag | grep RELEASE`; do
    echo bench.sh $t
    ../parrot-bench/bench.sh $t
fi

# TODO: data processing and graph creation
