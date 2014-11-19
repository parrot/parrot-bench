#!/bin/sh
for p in ../parrot-bench/*.pasm ../parrot-bench/*.pir
do 
    ./parrot_old $PARROT_ARGS $p >/dev/null
done
