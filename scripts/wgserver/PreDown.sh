#!/bin/bash

# Disallow wireguard iptables base rules
iptables -D FORWARD -i %i -j ACCEPT
iptables -D FORWARD -o %i -j ACCEPT
iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE

