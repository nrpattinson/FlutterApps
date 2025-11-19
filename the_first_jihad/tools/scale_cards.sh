mkdir -p cards75
mkdir -p cards150
for F in cards300/*.png
do
	echo $F

	O=${F/300/75}
	convert $F -colorspace RGB -resize 25% -colorspace sRGB $O

	O=${F/300/150}
	convert $F -colorspace RGB -resize 50% -colorspace sRGB $O
done
