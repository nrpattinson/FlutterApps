mkdir -p tmp

# squares
ROW=1
for TOP in 305 680 1132 1508 1955 2331 2779 3155 3605 3981 4429
do
	COL=1
	RCOL=16
	for LEFT in 159 534 909 1284 1660 2035 2410 2785 3454 3830 4205 4580 4955 5330 5705 6081
	do
		if [[ ${ROW} -eq 11 && ${COL} -lt 9 ]]; then
			LEFT=$(expr $LEFT - 4)
		fi
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 365 -height 365 HIRES/countersFront.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		if [[ ${ROW} -eq 2 && ${COL} -ge 3 && ${COL} -lt 9 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}_f.ppm > tmp/counter_0_0_f.ppm
			rm tmp/counter_${ROW}_${COL}_f.ppm
			mv tmp/counter_0_0_f.ppm tmp/counter_${ROW}_${COL}_f.ppm
		fi
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 365 -height 365 HIRES/countersBack.ppm > tmp/counter_0_0_b.ppm
		if [[ ${ROW} -eq 2 && ${RCOL} -eq 3 ]]; then
			mv tmp/counter_0_0_b.ppm tmp/counter_${ROW}_${RCOL}_b.ppm
		else
			pnmflip -r180 tmp/counter_0_0_b.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		fi
		rm tmp/counter_0_0_b.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done


