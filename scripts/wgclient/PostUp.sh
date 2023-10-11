#!/bin/bash

# Allow traffic through Wireguard interface
iptables -t nat -A POSTROUTING -o wg+ -j MASQUERADE

# Port forward
json_file="/scripts/wgclient/forward.json"

if [ -f "$json_file" ]; then
    data_array=($(jq -r 'to_entries[] | .key + ":" + .value' "$json_file"))
    for pair in "${data_array[@]}"; do
        client_ip=$(ping -c 1 "${pair%%:*}" | awk -F '[()]' '/PING/{print $2}' | head -n 1)
        client_port="${pair##*:}"
        if [ -n "$client_ip" ]; then
            echo "Forwarding ${pair%%:*} as $client_ip:$client_port"
            iptables -t nat -A PREROUTING -p tcp --dport "$client_port" -j DNAT --to-destination "$client_ip:$client_port"
        else
            echo "/!\ Failed to get IP address of ${pair%%:*}"
        fi
    done
else
    echo "/!\ $json_file not found"
fi

# Reject traffic not going through the Wireguard interface
iptables -I OUTPUT ! -o "%i" -m mark ! --mark "$(wg show %i fwmark)" -m addrtype ! --dst-type LOCAL -j REJECT
ip6tables -I OUTPUT ! -o "%i" -m mark ! --mark "$(wg show %i fwmark)" -m addrtype ! --dst-type LOCAL -j REJECT
