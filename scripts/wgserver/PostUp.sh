#!/bin/bash

# Allow wireguard iptables base rules
iptables -A FORWARD -i %i -j ACCEPT
iptables -A FORWARD -o %i -j ACCEPT
iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE

# Port forward 32400

PORT=32400
CLIENT=10.66.66.2

iptables -A FORWARD -i eth+ -o %i -p tcp --syn --dport $PORT -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -A PREROUTING -i eth+ -p tcp --dport $PORT -j DNAT --to-destination $CLIENT
iptables -t nat -A POSTROUTING -o %i -p tcp --dport $PORT -d $CLIENT -j SNAT --to-source $1

iptables -A FORWARD -i eth+ -o %i -p udp --dport $PORT -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -A PREROUTING -i eth+ -p udp --dport $PORT -j DNAT --to-destination $CLIENT
iptables -t nat -A POSTROUTING -o %i -p udp --dport $PORT -d $CLIENT -j SNAT --to-source $1
