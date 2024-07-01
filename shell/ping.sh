#!/bin/bash

# List of servers to ping
servers=(
    "192.168.17.228"
    "192.168.17.229"
    "192.168.17.214"
    "192.168.17.202"
    "172.16.113.107"
    "172.16.113.108"
    "172.16.113.111"
    )

# Loop through each server
for server in "${servers[@]}"; do
  echo "Pinging $server..."
  
  # Ping the server (sending only 1 packet and waiting a maximum of 1 second for a response)
  if ping -c 1 -W 1 "$server" > /dev/null 2>&1; then
    echo "SUCCESS: $server is reachable."
  else
    echo "FAIL: $server is not reachable."
  fi

  echo # Print a blank line for better readability
done