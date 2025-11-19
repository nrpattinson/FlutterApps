mkdir -p counters96

for F in counters144/*.png
do
	echo $F

	O=${F/144/96}
	convert $F -colorspace RGB -resize 66.7% -colorspace sRGB $O
done
