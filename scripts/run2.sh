#!/bin/sh -e

set -x

#ROOT=$HOME/Perso/charls-test-data

PATH=$PATH:$HOME/Perso/charls-tools/bin:$HOME/Perso/charls/bin/test

rm -rf pnm
rm -rf jls
rm -rf jpeg
rm -rf jlst

mkdir pnm
mkdir jls
mkdir jpeg
mkdir jlst

for depth in $(seq 2 16); do
  #convert -depth $depth -size 512x512 xc:black pnm/black_$depth.pnm
  #convert -depth $depth -size 512x512 xc:gray  pnm/gray_$depth.pnm
  #convert -depth $depth -size 512x512 xc:white pnm/white_$depth.pnm
  #
  convert -depth $depth -size 512x512 xc:red   pnm/red_$depth.pnm
  convert -depth $depth -size 512x512 xc:green pnm/green_$depth.pnm
  convert -depth $depth -size 512x512 xc:blue  pnm/blue_$depth.pnm
done

for pnm in pnm/*; do
  fn=$(basename $pnm .pnm)
  # encodepnm default to 'line' instead of 'none' for RGB:
  charlstest -encodepnm $pnm jls/$fn.jls
  jpeg -c -ls 1 $pnm jpeg/$fn.jls
  cjpls --interleave_mode line $pnm jlst/$fn.jls
  # now decompress
  charlstest -decodetopnm jls/$fn.jls jls/$fn.pnm
  jpeg jpeg/$fn.jls jpeg/$fn.pnm
  djpls jlst/$fn.jls jlst/$fn.pnm
done

md5sum pnm/*.pnm > /tmp/pnm
md5sum jls/*.pnm > /tmp/jls
md5sum jpeg/*.pnm > /tmp/jpeg
md5sum jlst/*.pnm > /tmp/jlst

md5sum jls/*.jls > /tmp/jls2
md5sum jlst/*.jls > /tmp/jlst2
