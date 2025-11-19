mkdir -p tmp

# squares
ROW=1
for TOP in 204 454 754 1004 1304 1554 1854 2104 2404 2654 2954
do
	COL=1
	RCOL=16
	for LEFT in 107 357 607 857 1107 1357 1607 1857 2303 2553 2803 3053 3303 3553 3803 4053
	do
		echo counter $ROW $COL
		if [[ ${COL} -le 8 ]]; then
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 243 -height 243 HIRES/counters.ppm > tmp/counter_${ROW}_${COL}_f.ppm
		else
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 243 -height 243 HIRES/counters.ppm > tmp/counter_${ROW}_${RCOL}_b.ppm
		fi
		COL=$(expr $COL + 1)
		RCOL=$(expr $RCOL - 1)
	done
	ROW=$(expr $ROW + 1)
done

