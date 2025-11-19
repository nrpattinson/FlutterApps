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
		if [[ ${COL} -le 8 ]]; then
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 368 -height 368 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		else
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 368 -height 368 HIRES/counters.ppm > tmp/counter_0_0_b.ppm
			pnmflip -r180 tmp/counter_0_0_b.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
			rm tmp/counter_0_0_b.ppm
		fi
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

