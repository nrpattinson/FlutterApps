cd ..
for Pathname in assets/images/*
do
	if [ -f "$Pathname" ]; then
		echo "   - $Pathname"
	fi
done
