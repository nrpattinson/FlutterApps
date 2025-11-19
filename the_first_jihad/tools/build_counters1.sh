mkdir -p tmp

# squares
ROW=1
for TOP in 151 339 564 751 976 1164 1389 1576 1801 1989
do
	COL=1
	for LEFT in 76 264 451 639 826 1014 1201 1389 1726 1914 2101 2289 2476 2664 2851 3039
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 184 -height 184 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		if [[ ${COL} -ge 9 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}.ppm > tmp/counter_0_0.ppm
			if [[ ${ROW} -eq 2 && ( ${COL} -eq 15 || ${COL} -eq 16 ) ]]; then
				mv tmp/counter_${ROW}_${COL}.ppm tmp/counter_${ROW}_${COL}_u.ppm
			else
				rm tmp/counter_${ROW}_${COL}.ppm
			fi
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}.ppm
		fi
		COL=$(expr $COL + 1)
	done
	ROW=$(expr $ROW + 1)
done


