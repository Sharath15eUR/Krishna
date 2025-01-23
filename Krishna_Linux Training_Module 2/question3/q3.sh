#Question3: Use the appropriate command to search for lines containing the word "ERROR" in a log file but exclude lines containing "DEBUG". Save the results to a file named filtered_log.txt.

#Commands

(cat q3.sh; cat log.txt; grep "ERROR" log.txt | grep -v "DEBUG" > filtered_log.txt; echo "Filtered Only"; cat filtered_log.txt) > output.txt


#Output
