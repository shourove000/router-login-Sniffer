# router-login-Sniffer
this script is used to capture router's login username and password

requirements :
*Linux terminal
*bettercap
*iptables

Features:
Automatic network interface and gateway detection.
Single-click start with confirmation.
Auto-cleans iptables and network settings when stopped.
Focuses only on 192.168.0.1 HTTP traffic.
Captures credentials through Bettercap.
Preserves your own internet access while blocking others.

How it works:
Uses ARP spoofing to redirect traffic.
Blocks all traffic except gateway via iptables.
Filters sniffing to only show router's web page traffic.
Shows captured credentials directly in the terminal.
Automatically restores network when stopped.

NOTE:
THE PASSWORD WILL BE SHOWN IN Base64 ENCODED.
SO,IT NEEDED TO BE DECODED.
USING THIS COMMEND:


---> echo "[PASSWORD]" | base64 -d        #REPLACE [PASSWORD] TO CAPTURED PASSWORD.
