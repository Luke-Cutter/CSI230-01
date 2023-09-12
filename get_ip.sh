#Runs the ip addr command and filters the output
ip_addr_output=$(ip addr)

#Uses grep to find lines using the IP address and subnet mask
ip_info=$(echo "$ip_addr_output" | grep -Eo '192\.168\.[0-9]+\.[0-9]+/[0-9]+')

#Uses awk to print the first occurrence of the IP address and subnet mask
formatted_ip=$(echo "$ip_info")

#Print the result
echo "Your IP address is: $formatted_ip"
