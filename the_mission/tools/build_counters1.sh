mkdir -p tmp

# squares
ROW=1
for TOP in 153 340 565 753 977 1165 1390 1578 1802 1990 2214
do
	COL=1
	RCOL=16
	for LEFT in 82 270 458 645 833 1020 1207 1395 1732 1920 2107 2295 2482 2670 2857 3045
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 180 -height 180 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

ROW=1
for TOP in 153 340 565 753 977 1165 1390 1578 1802 1990 2214
do
	COL=1
	RCOL=16
	for LEFT in 80 267 455 642 830 1017 1205 1392 1729 1917 2104 2292 2479 2667 2854 3042
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 180 -height 180 HIRES/counters_back.ppm > tmp/counter_0_0.ppm
		pnmflip -r180 tmp/counter_0_0.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		rm tmp/counter_0_0.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

