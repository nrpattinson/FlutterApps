mkdir -p cards96
mkdir -p cards192
for F in cards300/*.png
do
	echo $F

	O=${F/300/96}
	convert $F -colorspace RGB -resize 32.0% -colorspace sRGB $O

	O=${F/300/192}
	convert $F -colorspace RGB -resize 64.0% -colorspace sRGB $O
done
