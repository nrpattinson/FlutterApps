mkdir -p tmp

# squares
ROW=1
for TOP in 307 681 1133 1509 1957 2333 2781 3157 3607 3983 4431
do
	COL=1
	RCOL=24
	for LEFT in 159 533 909 1283 1659 2033 2409 2783 3455 3831 4205 4581 4955 5330 5705 6082
	do
		echo counter $ROW $COL
		if [[ ${COL} -lt 9 ]]; then
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 360 -height 360 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}.ppm
		else
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 360 -height 360 HIRES/counters.ppm > tmp/counter_${ROW}_${RCOL}.ppm
			pnmflip -r180 tmp/counter_${ROW}_${RCOL}.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${RCOL}.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${RCOL}.ppm
		fi
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done


