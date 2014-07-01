#!/bin/sh
for p in ../parrot-bench/*.pasm ../parrot-bench/*.pir
do 
    ./parrot_old $p >/dev/null
done
