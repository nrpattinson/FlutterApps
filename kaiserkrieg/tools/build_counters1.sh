mkdir -p tmp

# squares
ROW=1
for TOP in 309 683 1135 1511 1959 2335 2783 3159 3609 3985 4433
do
	COL=1
	RCOL=16
	for LEFT in 161 535 911 1285 1662 2035 2412 2785 3458 3833 4208 4584 4957 5333 5707 6084
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 360 -height 360 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		if [[ ${ROW} -eq 10 && ${COL} -ge 10 && ${COL} -le 14 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}_f.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${COL}_f.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}_f.ppm
		fi
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done


