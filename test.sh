#! /bin/sh

for f in ./test/*.lua; do
	if [ -f "$f" ]; then
		lua $f
	fi

	if [ $? -eq 0 ]; then
		echo "PASSED $f"
	else
		echo "FAILED $f"
	fi
done
