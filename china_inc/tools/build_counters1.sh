mkdir -p tmp

# squares
ROW=1
for TOP in 63 213 400 550 738 888 1075 1225 1413 1563 1751 1901 2088 2238
do
	COL=1
	RCOL=20
	for LEFT in 163 313 463 613 763 913 1063 1213 1363 1513 1763 1913 2063 2213 2363 2513 2663 2813 2963 3113
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 142 -height 142 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 142 -height 142 HIRES/counters_back.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

