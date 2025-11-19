mkdir -p cards96
mkdir -p cards192
for F in cards400/*.png
do
	echo $F

	O=${F/400/96}
	convert $F -colorspace RGB -resize 24.0% -colorspace sRGB $O

	O=${F/400/192}
	convert $F -colorspace RGB -resize 48.0% -colorspace sRGB $O
done
