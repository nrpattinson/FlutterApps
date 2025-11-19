mkdir -p tmp

# squares
ROW=1
for TOP in 152 340 565 753 978 1165 1390 1577 1802 1990 2214
do
	COL=1
	RCOL=8
	for LEFT in 78 266 453 641 828 1016 1203 1391
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 184 -height 184 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 184 -height 184 HIRES/counters_back.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

