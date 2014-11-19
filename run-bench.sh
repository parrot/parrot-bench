#!/bin/sh
for p in ../parrot-bench/*.pasm ../parrot-bench/*.pir
do 
    ./parrot $PARROT_ARGS $p >/dev/null
done
