mkdir -p tmp

# squares
for FILE in {1..3};
do
	ROW=1
	for TOP in 0 1100 2200
	do
		COL=1
		for LEFT in 0 850 1700
		do
			CARD=$(($(($FILE-1))*9+$(($ROW-1))*3+$COL))
			echo card $FILE $ROW $COL ${CARD}
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 850 -height 1100 HIRES/cards${FILE}.ppm > tmp/card_${CARD}.ppm
			COL=$(expr $COL + 1)
		done
		ROW=$(expr $ROW + 1)
	done
	FILE=$(expr $FILE + 1)
done
