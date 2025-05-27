自动创建节点

#!/bin/bash
 
filename="xui.txt"
output_file="vmess.txt"
cookie_file="cookies.txt"
 
# Function to clear cookie file
clear_cookie_file() {
  if [ -f "$cookie_file" ]; then
    rm "$cookie_file"
  fi
}
 
# Function to generate vmess link
generate_vmess_link() {
  local ip=$1
  local port=$2
  local id=$3
 
  vmess_json=$(cat <<EOF
{
  "v": "2",
  "ps": "",
  "add": "$ip",
  "port": $port,
  "id": "$id",
  "aid": 0,
  "net": "ws",
  "type": "none",
  "host": "",
  "path": "/",
  "tls": "none"
}
EOF
)
 
  vmess_base64=$(echo -n "$vmess_json" | base64 -w 0)
  echo "vmess://$vmess_base64"
}
 
# Read each line from the file and process
while IFS= read -r ip; do
  echo "Processing IP: $ip"
 
  # Clear cookie file before each iteration
  clear_cookie_file
 
  # Flag to check if addition was successful
  addition_success=false
 
  # Try HTTP first
  login_response=$(curl -s -c "$cookie_file" -X POST http://$ip:54321/login -H "Content-Type: application/json" -d '{
    "username": "admin",
    "password": "admin"
  }')
 
  # Check if the HTTP login was successful
  if echo "$login_response" | grep -q '"success":true'; then
    echo "HTTP Login successful"
 
    # Prepare JSON data for the subsequent request (adjust according to your vmess configuration)
    data=$(cat <<EOF
{
  "up": 0,
  "down": 0,
  "total": 0,
  "remark": "",
  "enable": true,
  "expiryTime": 0,
  "listen": "",
  "port": 20292,
  "protocol": "vmess",
  "settings": "{\"clients\":[{\"id\":\"57f5c2bd-bb79-4fd8-eea1-a84d1ddf3a21\",\"alterId\":0}],\"disableInsecureEncryption\":false}",
  "streamSettings": "{\"network\":\"ws\",\"security\":\"none\",\"wsSettings\":{\"path\":\"/\",\"headers\":{}}}",
  "sniffing": "{\"enabled\":true,\"destOverride\":[\"http\",\"tls\"]}"
}
EOF
)
 
    # URL for HTTP
    url="http://$ip:54321/xui/inbound/add"
 
    # Use the session cookie to make the HTTP request
    response=$(curl -s -b "$cookie_file" -X POST "$url" -H "Content-Type: application/json" -d "$data")
 
    # Print verbose output for debugging
    echo "Verbose output:"
    echo "$response"
 
    # Check if the addition was successful and print the vmess link
    if echo "$response" | grep -q '"success":true'; then
      echo "Addition successful. Generating vmess link..."
      vmess_link=$(generate_vmess_link "$ip" 20292 "57f5c2bd-bb79-4fd8-eea1-a84d1ddf3a21")
      echo "Vmess link: $vmess_link"
 
      # Append the vmess link to the output file
      echo "$vmess_link" >> "$output_file"
 
      # Mark addition as successful
      addition_success=true
    else
      echo "Addition failed. Response: $response"
    fi
 
  else
    echo "HTTP Login failed. Trying HTTPS..."
 
    # Try HTTPS with certificate skipping first
    login_response=$(curl -k -s -c "$cookie_file" --tlsv1.2 -X POST https://$ip:54321/login -H "Content-Type: application/json" -d '{
      "username": "admin",
      "password": "admin"
    }')
 
    # Check if the HTTPS login was successful
    if echo "$login_response" | grep -q '"success":true'; then
      echo "HTTPS Login successful"
 
      # Prepare JSON data for the HTTPS request (adjust according to your vmess configuration)
      data=$(cat <<EOF
{
  "up": 0,
  "down": 0,
  "total": 0,
  "remark": "",
  "enable": true,
  "expiryTime": 0,
  "listen": "",
  "port": 20292,
  "protocol": "vmess",
  "settings": "{\"clients\":[{\"id\":\"57f5c2bd-bb79-4fd8-eea1-a84d1ddf3a21\",\"alterId\":0}],\"disableInsecureEncryption\":false}",
  "streamSettings": "{\"network\":\"ws\",\"security\":\"none\",\"wsSettings\":{\"path\":\"/\",\"headers\":{}}}",
  "sniffing": "{\"enabled\":true,\"destOverride\":[\"http\",\"tls\"]}"
}
EOF
)
 
      # URL for HTTPS
      url="https://$ip:54321/xui/inbound/add"
 
      # Use the session cookie to make the HTTPS request
      response=$(curl -s -b "$cookie_file" --tlsv1.2 -X POST "$url" -H "Content-Type: application/json" -d "$data")
 
      # Print verbose output for debugging
      echo "Verbose output:"
      echo "$response"
 
      # Check if the addition was successful and print the vmess link
      if echo "$response" | grep -q '"success":true'; then
        echo "Addition successful. Generating vmess link..."
        vmess_link=$(generate_vmess_link "$ip" 20292 "57f5c2bd-bb79-4fd8-eea1-a84d1ddf3a21")
        echo "Vmess link: $vmess_link"
 
        # Append the vmess link to the output file
        echo "$vmess_link" >> "$output_file"
 
        # Mark addition as successful
        addition_success=true
      else
        echo "Addition failed. Response: $response"
      fi
 
    else
      echo "HTTPS Login failed. Skipping to next IP."
    fi
  fi
 
  # Clear cookie file after each iteration
  clear_cookie_file
 
done < "$filename"
 
# Clear cookie file after finishing all iterations
clear_cookie_file
