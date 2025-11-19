mkdir -p tmp

# squares
ROW=1
for TOP in 157 345 568 756 981 1169 1392 1580 1804 1992 2217
do
	COL=1
	RCOL=16
	for LEFT in 82 270 457 644 831 1019 1207 1395 1726 1914 2102 2290 2477 2665 2852 3040
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 176 -height 176 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 176 -height 176 HIRES/counters_back.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done


