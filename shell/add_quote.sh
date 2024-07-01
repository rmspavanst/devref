#!/bin/bash

# Input file containing IP addresses
input_file="ipadd.txt"

# Output file to store IP addresses with quotes
output_file="quoted_ipadd1.txt"

# Loop through each line in the input file
while IFS= read -r ip_address; do
  # Add quotes around each IP address and write to the output file
  echo "\"$ip_address\"" >> "$output_file"
done < "$input_file"

# Print the content of the output file
cat "$output_file"