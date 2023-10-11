#!/usr/bin/with-contenv bash
echo "**** start 01-change_ip_route.sh ****"
echo "---> install packages"

if [ -f /usr/bin/apt ]; then
  ## Ubuntu
  apt update
  apt install --no-install-recommends -y \
    iptables \
    jq \
    iproute2 
fi
if [ -f /sbin/apk ]; then
  # Alpine
  apk add --no-cache \
    iptables \
    jq \
    iproute2
fi

echo "---> set default route to wireguard the container"

if [ -n "$WG_CONTAINER_NAME" ]; then
    WG_IP_ADDR=$(ping -c 1 $WG_CONTAINER_NAME | awk -F '[()]' '/PING/{print $2}' | head -n 1)
    if [ -n "$WG_IP_ADDR" ]; then
        echo "Adresse IP de $WG_CONTAINER_NAME : $WG_IP_ADDR"
        ip route del default
        ip route add default via $WG_IP_ADDR
    else
        echo "/!\ failed to get IP address of the wireguard container"
    fi
else
    echo "/!\ WG_CONTAINER_NAME is not set"
fi
