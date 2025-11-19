mkdir -p counters96
mkdir -p counters192
for F in counters300/*.png
do
	echo $F

	O=${F/300/96}
	convert $F -colorspace RGB -resize 34% -colorspace sRGB $O

	O=${F/300/192}
	convert $F -colorspace RGB -resize 68% -colorspace sRGB $O
done
