#Question5: Use the networking tool command and print all the gateway available in a sorted manner

#Commands

(cat q5.sh; ip route | grep default | awk '{print}' | sort -u; echo "Gateway Alone"; ip route | grep default | awk '{print $3}' | sort -u) > output.txt


#Output
