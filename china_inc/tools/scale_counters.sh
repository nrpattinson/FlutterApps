mkdir -p counters96
mkdir -p counters144

for F in counters300/*.png
do
	echo $F

	O=${F/300/96}
	convert $F -colorspace RGB -resize 33.8% -colorspace sRGB $O

	O=${F/300/144}
	convert $F -colorspace RGB -resize 50.7% -colorspace sRGB $O
done
