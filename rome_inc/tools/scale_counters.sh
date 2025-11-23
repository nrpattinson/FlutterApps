mkdir -p counters96
mkdir -p counters144

for F in counters180/*.png
do
	echo $F

	O=${F/180/96}
	convert $F -colorspace RGB -resize 53.3% -colorspace sRGB $O

	O=${F/180/144}
	convert $F -colorspace RGB -resize 80.0% -colorspace sRGB $O
done
