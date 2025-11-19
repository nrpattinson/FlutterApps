mkdir -p tmp

# squares
ROW=1
for TOP in 149 338 563 751 975 1163 1387 1575 1800 1988 2212
do
	COL=1
	for LEFT in 79 267 454 641 828 1016 1204 1391
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 182 -height 182 HIRES/Counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		COL=$(expr $COL + 1)
	done
	ROW=$(expr $ROW + 1)
done

