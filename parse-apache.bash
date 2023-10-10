#!/bin/bash

read -p "Please enter an Apache log file: " tFile

if [[ ! -f ${tFile} ]]; then
  echo "File doesn't exist."
  exit 1
fi

# Extract unique IP addresses from the Apache log and sort them
ips=$(awk '{print $1}' ${tFile} | sort -u)

# Specify the filename for the IPTables rules file
rules_file="your_existing_rules.txt"

# Append IPTables rules to the existing file
for ip in $ips; do
  echo "iptables -A INPUT -s $ip -j ACCEPT" >> "$rules_file"
done

echo "IPTables rules have been appended to $rules_file."
