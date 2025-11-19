mkdir -p tmp

# squares
ROW=1
for TOP in 176 400 664 888 1151 1375 1639 1863 2125
do
	COL=1
	for LEFT in 62 287 512 736 961 1185 
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 215 -height 215 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		COL=$(expr $COL + 1)
	done
	RCOL=6
	for LEFT in 1861 2086 2311 2535 2760 2984 
	do
		echo counter $ROW $RCOL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 215 -height 215 HIRES/counters.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

