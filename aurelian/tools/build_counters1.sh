mkdir -p tmp

# squares
ROW=1
for TOP in 175 417 709 951 1243 1486 1776 2019 2310 2554 2843
do
	COL=1
	for LEFT in 79 322 565 807 1050 1292 1535 1777
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 230 -height 230 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		COL=$(expr $COL + 1)
	done
	RCOL=8
	for LEFT in 2211 2453 2696 2938 3182 3424 3667 3910
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 230 -height 230 HIRES/counters.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

