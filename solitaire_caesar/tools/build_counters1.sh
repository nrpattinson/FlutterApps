mkdir -p tmp

# squares
ROW=1
for TOP in 151 340 564 753 977 1165 1389 1578 1803 1990 2214
do
	COL=1
	for LEFT in 77 265 453 640 828 1015 1203 1390 1726 1913 2101 2288 2476 2663 2851 3039
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 184 -height 184 HIRES/Counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		COL=$(expr $COL + 1)
	done
	ROW=$(expr $ROW + 1)
done

