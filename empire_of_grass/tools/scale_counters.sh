mkdir -p counters96
mkdir -p counters192
for F in counters400/*.png
do
	echo $F

	O=${F/400/96}
	convert $F -colorspace RGB -resize 24.7% -colorspace sRGB $O

	O=${F/400/192}
	convert $F -colorspace RGB -resize 49.4% -colorspace sRGB $O
done
