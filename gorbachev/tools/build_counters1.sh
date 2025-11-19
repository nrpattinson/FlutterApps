mkdir -p tmp

# squares
ROW=1
for TOP in 155 343 568 756 981 1168 1393 1580 1805 1993 2217
do
	COL=1
	for LEFT in 81 269 456 644 831 1019 1206 1394
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 179 -height 179 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		if [[ ${ROW} -eq 10 && ${COL} -eq 1 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${COL}.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}.ppm
		fi
		COL=$(expr $COL + 1)
	done
	ROW=$(expr $ROW + 1)
done

