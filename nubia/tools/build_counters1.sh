mkdir -p tmp

# squares
ROW=1
for TOP in 309 683 1135 1511 1959 2335 2783 3159 3609 3985 4433
do
	COL=1
	for LEFT in 160 535 910 1285 1660 2035 2410 2785
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 360 -height 360 HIRES/Counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		if [[ ${ROW} -eq 8 && ${COL} -eq 6 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${COL}.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}.ppm
		fi
		COL=$(expr $COL + 1)
	done
	ROW=$(expr $ROW + 1)
done

