mkdir -p tmp

# squares
ROW=1
for TOP in 307 682 1134 1509 1957 2333 2781 3157 3607 3983 4431
do
	COL=1
	RCOL=16
	for LEFT in 159 533 909 1284 1659 2034 2410 2784 3456 3831 4206 4581 4955 5331 5705 6082
	do
		if [[ ${ROW} -eq 11 && ${COL} -lt 9 ]]; then
			LEFT=$(expr $LEFT - 4)
		fi
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 360 -height 360 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		if [[ ${ROW} -eq 6 && ${COL} -ge 9 && ${COL} -lt 14 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}_f.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${COL}_f.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}_f.ppm
		fi
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 360 -height 360 HIRES/counters_back.ppm > tmp/counter_0_0.ppm
		if [[ ${ROW} -eq 5 && ${RCOL} -ge 9 && ${RCOL} -lt 15 ]]; then
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${RCOL}_b.ppm
		else
			pnmflip -r180 tmp/counter_0_0.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
			rm tmp/counter_0_0.ppm
		fi
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done


