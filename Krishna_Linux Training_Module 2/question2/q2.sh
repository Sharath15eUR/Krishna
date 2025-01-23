#Question2: Replace all occurrences of "localhost" with "127.0.0.1" in config.txt and save as updated_config.txt

#Commands

(cat q2.sh; cat config.txt; sed 's/localhost/127.0.0.1/g' config.txt > updated_config.txt; cat updated_config.txt) > output.txt


#Output
