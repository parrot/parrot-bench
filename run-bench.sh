#!/bin/sh
for p in ../parrot-bench/*.pasm ../parrot-bench/*.pir
do 
    ./parrot $p >/dev/null
done
