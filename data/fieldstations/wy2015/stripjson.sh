for file in *.json; do
	base=$(basename "$file" .json)
	echo $base;
	mv $file $base
done;