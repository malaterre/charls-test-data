#!/bin/sh -e

#set -x

#ROOT=/home/mathieu/Perso/charls-test-data

rm -rf pgm
rm -rf jls
rm -rf jpeg

mkdir pgm
mkdir jls
mkdir jpeg

convert -depth 8 -size 512x512 xc:white pgm/white8.pgm
convert -depth 16 -size 512x512 xc:white pgm/white16.pgm
convert -comment "a comment" -depth 8 -size 512x512 xc:white pgm/white8_com.pgm
convert -comment "a\nmulti\nline\ncomment" -depth 8 -size 512x512 xc:white pgm/white8_com2.pgm

for depth in $(seq 2 16); do
  convert -depth $depth -size 512x512 xc:white pgm/depth_$depth.pgm
done

for pgm in pgm/*; do
  fn=$(basename $pgm .pgm)
  charlstest -encodepnm $pgm jls/$fn.jls
  jpeg -ls 0 $pgm jpeg/$fn.jls
  # now decompress
  charlstest -decodetopnm jls/$fn.jls jls/$fn.pgm
  jpeg jpeg/$fn.jls jpeg/$fn.pgm
done
