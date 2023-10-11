#!/bin/bash

# Disallow wireguard iptables base rules
# $1 is the interface name
iptables -D FORWARD -i $1 -j ACCEPT
iptables -D FORWARD -o $1 -j ACCEPT
iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE

