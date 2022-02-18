#!/bin/sh -e

set -x

#ROOT=$HOME/Perso/charls-test-data

PATH=$PATH:$HOME/Perso/charls-tools/bin:$HOME/Perso/charls/bin/test

rm -rf pnm
rm -rf none
rm -rf none2
rm -rf line
rm -rf line2
rm -rf sample
rm -rf sample2

mkdir pnm
mkdir none
mkdir none2
mkdir line
mkdir line2
mkdir sample
mkdir sample2

for depth in $(seq 2 16); do
  convert -depth $depth -size 512x512 xc:red   pnm/red_$depth.pnm
  convert -depth $depth -size 512x512 xc:green pnm/green_$depth.pnm
  convert -depth $depth -size 512x512 xc:blue  pnm/blue_$depth.pnm
done

for pnm in pnm/*; do
  fn=$(basename $pnm .pnm)
  cjpls --interleave_mode none   $pnm none/$fn.jls
  cjpls --interleave_mode line   $pnm line/$fn.jls
  cjpls --interleave_mode sample $pnm sample/$fn.jls
  # now decompress
  charlstest -decodetopnm none/$fn.jls   none/$fn.pnm
  charlstest -decodetopnm line/$fn.jls   line/$fn.pnm
  charlstest -decodetopnm sample/$fn.jls sample/$fn.pnm
  #
  djpls none/$fn.jls none2/$fn.pnm
  djpls line/$fn.jls line2/$fn.pnm
  djpls sample/$fn.jls sample2/$fn.pnm
done

md5sum pnm/*.pnm > /tmp/pnm
md5sum none/*.pnm   > /tmp/none
md5sum line/*.pnm   > /tmp/line
md5sum sample/*.pnm > /tmp/sample

md5sum none2/*.pnm   > /tmp/none2
md5sum line2/*.pnm   > /tmp/line2
md5sum sample2/*.pnm > /tmp/sample2

