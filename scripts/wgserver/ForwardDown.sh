#!/bin/bash

# Disallow port forward
# $1 is the interface name
# $2 is the port to forward
# $3 is the client IP to forward to

INTERFACE_IP=$(wg show $1 allowed-ips 0.0.0.0/0 | awk '{print $4}')

iptables -D FORWARD -i eth+ -o $1 -p tcp --syn --dport $2 -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -D PREROUTING -i eth+ -p tcp --dport $2 -j DNAT --to-destination $3
iptables -t nat -D POSTROUTING -o $1 -p tcp --dport $2 -d $3 -j SNAT --to-source $INTERFACE_IP

iptables -D FORWARD -i eth+ -o $1 -p udp --dport $2 -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -D PREROUTING -i eth+ -p udp --dport $2 -j DNAT --to-destination $3
iptables -t nat -D POSTROUTING -o $1 -p udp --dport $2 -d $3 -j SNAT --to-source $INTERFACE_IP