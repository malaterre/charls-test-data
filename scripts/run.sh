#!/bin/sh -e

set -x

#ROOT=$HOME/Perso/charls-test-data

PATH=$PATH:$HOME/Perso/charls-tools/bin:$HOME/Perso/charls/bin/test

rm -rf pgm
rm -rf jls
rm -rf jpeg
rm -rf jlst

mkdir pgm
mkdir jls
mkdir jpeg
mkdir jlst

#convert -depth 8 -size 512x512 xc:white pgm/white8.pgm
#convert -depth 16 -size 512x512 xc:white pgm/white16.pgm
#convert -comment "a comment" -depth 8 -size 512x512 xc:white pgm/white8_com.pgm
#convert -comment "a\nmulti\nline\ncomment" -depth 8 -size 512x512 xc:white pgm/white8_com2.pgm

for depth in $(seq 2 16); do
  convert -depth $depth -size 512x512 xc:black pgm/black_$depth.pgm
  convert -depth $depth -size 512x512 xc:gray  pgm/gray_$depth.pgm
  convert -depth $depth -size 512x512 xc:white pgm/white_$depth.pgm
done

for pgm in pgm/*; do
  fn=$(basename $pgm .pgm)
  charlstest -encodepnm $pgm jls/$fn.jls
  jpeg -c -ls 0 $pgm jpeg/$fn.jls
  cjpls --interleave_mode none $pgm jlst/$fn.jls
  # now decompress
  charlstest -decodetopnm jls/$fn.jls jls/$fn.pgm
  jpeg jpeg/$fn.jls jpeg/$fn.pgm
  djpls jlst/$fn.jls jlst/$fn.pgm
done

md5sum pgm/*.pgm > /tmp/pgm
md5sum jls/*.pgm > /tmp/jls
md5sum jpeg/*.pgm > /tmp/jpeg
md5sum jlst/*.pgm > /tmp/jlst

md5sum jls/*.jls > /tmp/jls2
md5sum jlst/*.jls > /tmp/jlst2
