#Question: List all files larger than 1MB in the current directory and save the output to a file

#Command
(cat q1.sh; find . -type f -size +1M -exec ls -lh {} +) > output.txt

#Output
