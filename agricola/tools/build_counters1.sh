mkdir -p tmp

# squares
ROW=1
for TOP in 152 339 565 752 977 1165 1389 1577 1802 1990 2214
do
	COL=1
	for LEFT in 78 265 453 640 828 1015 1203 1390
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 178 -height 178 HIRES/AMB_CS.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		COL=$(expr $COL + 1)
	done
	RCOL=8
	for LEFT in 1726 1913 2101 2288 2476 2663 2851 3039
	do
		echo counter $ROW $RCOL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 178 -height 178 HIRES/AMB_CS.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

