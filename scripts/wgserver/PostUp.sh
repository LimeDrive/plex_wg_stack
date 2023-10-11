#!/bin/bash

# Allow wireguard iptables base rules
# $1 is the interface name
iptables -A FORWARD -i $1 -j ACCEPT
iptables -A FORWARD -o $1 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE