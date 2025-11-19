mkdir -p tmp

# squares
ROW=1
for TOP in 305 679 1131 1507 1955 2331 2779 3155 3605 3981 4429
do
	COL=1
	for LEFT in 157 531 907 1281 1657 2031 2407 2781
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 368 -height 368 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		COL=$(expr $COL + 1)
	done
	ROW=$(expr $ROW + 1)
done

