#!/bin/bash

# List of IP addresses and ports
addresses=(
    "192.168.17.228	5985	5986"
    "192.168.17.229	5985	5986"
    "192.168.17.214	5985	5986"
    "192.168.17.202	5985	5986"
    "172.16.113.107	5985	5986"
    "172.16.113.108	5985	5986"
)

# Function to check telnet connection
check_connection() {
    local ip=$1
    local port=$2

    # Attempt to connect using telnet
    timeout 5 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "Telnet to $ip on port $port successful."
    else
        echo "Telnet to $ip on port $port failed."
    fi
}

# Iterate over each address and port pair
for address in "${addresses[@]}"; do
    ip=$(echo $address | awk '{print $1}')
    port1=$(echo $address | awk '{print $2}')
    port2=$(echo $address | awk '{print $3}')

    check_connection $ip $port1
    check_connection $ip $port2
done