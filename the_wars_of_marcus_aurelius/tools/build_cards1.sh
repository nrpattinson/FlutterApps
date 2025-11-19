mkdir -p tmp

for SHEET in {1..6};
do
	ROW=1
	for TOP in 55 1120 2188
	do
		COL=1
		for LEFT in 72 897 1716 
		do
			CARD=$(($(($SHEET-1))*9+$((ROW-1))*3+$COL))
			echo card $SHEET $ROW $COL ${CARD}
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 757 -height 1057 HIRES/barb_card_sheet_${SHEET}.ppm > tmp/card_barb_${CARD}.ppm
			pnmcut -top $(expr $TOP) -left $(expr $LEFT) -width 757 -height 1057 HIRES/roman_card_sheet_${SHEET}.ppm > tmp/card_rome_${CARD}.ppm
			COL=$(expr $COL + 1)
		done
		ROW=$(expr $ROW + 1)
	done
done
echo card 7 1 1 back
pnmcut -top 55 -left 72 -width 757 -height 1057 HIRES/barb_card_sheet_back.ppm > tmp/card_barb_back.ppm
pnmcut -top 55 -left 72 -width 757 -height 1057 HIRES/roman_card_sheet_back.ppm > tmp/card_rome_back.ppm
