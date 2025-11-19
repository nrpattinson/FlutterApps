mkdir -p counters96
mkdir -p counters192
for F in counters600/*.png
do
	echo $F

	O=${F/600/96}
	convert $F -colorspace RGB -resize 16.7% -colorspace sRGB $O

	O=${F/600/192}
	convert $F -colorspace RGB -resize 33.3% -colorspace sRGB $O
done
