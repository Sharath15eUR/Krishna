#Question4: Write a code to identify the process with the highest memory usage and then terminate it

#Commands

(cat q4.sh; ps aux; ps aux | sort -nrk 4 | head -1 | awk '{system("kill -9 " $2)}'; echo "After Kill"; ps aux) > output.txt


#Output
