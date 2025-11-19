#!/bin/bash

# set -x

mkdir -p cards300

for F in tmp/card*.ppm
do
	echo $F

	O=${F/ppm/png}
	P=${O/tmp/cards300}

	pnmtopng $F > $P
done
