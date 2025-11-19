mkdir -p tmp

# squares
ROW=1
for TOP in 305 679 1131 1507 1955 2331 2779 3155 3605 3981 4429
do
	COL=1
	RCOL=16
	for LEFT in 157 531 907 1281 1657 2031 2407 2781 3453 3829 4203 4579 4953 5329 5703 6079
	do
		echo counter $ROW $COL
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 368 -height 368 HIRES/counters_front.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 368 -height 368 HIRES/counters_back.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		if [[ ${ROW} -eq 10 && ${COL} -le 8 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}_f.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${COL}_f.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}_f.ppm
		fi
		if [[ ${ROW} -eq 6 && ${COL} -ge 9 ]]; then
			pnmflip -r180 tmp/counter_${ROW}_${COL}_f.ppm > tmp/counter_0_0.ppm
			rm tmp/counter_${ROW}_${COL}_f.ppm
			mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${COL}_f.ppm
		fi
		pnmflip -r180 tmp/counter_${ROW}_${RCOL}_b.ppm > tmp/counter_0_0.ppm
		rm tmp/counter_${ROW}_${RCOL}_b.ppm
		mv tmp/counter_0_0.ppm tmp/counter_${ROW}_${RCOL}_b.ppm
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

