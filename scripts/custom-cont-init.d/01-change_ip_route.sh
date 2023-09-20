#! /bin/bash
echo "**** set default route to wireguard container ****"
ip route del default
ip route add default via 172.20.0.200