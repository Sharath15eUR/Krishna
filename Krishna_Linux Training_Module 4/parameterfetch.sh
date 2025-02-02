#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Give the input file"
	exit 1
fi

input="$1"
output="output.txt"

> "$output"

while IFS= read -r line; do
	if [[ "$line" == *"frame.time"* ]]; then
		echo "$line" | grep -o '"frame\.time".*' >> "$output"

	elif [[ "$line" == *"wlan.fc.type"* ]]; then
		echo "$line" | grep -o '"wlan\.fc\.type".*' >> "$output"

	elif [[ "$line" == *"wlan.fc.subtype"* ]]; then
                echo "$line" | grep -o '"wlan\.fc\.subtype".*' >> "$output"

	fi
done < "$input"

echo "Output redirected to $output"
