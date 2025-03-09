#!/bin/sh
if [ "$(cat /etc/hostid)" = "4e98920d" ]; then
  # Extract the MAC address using grep and cut.
  mac=$(ip link show eth0 | grep ether | head -n1 | cut -d" " -f2)
  newhostid=$(echo "$mac" | sed 's/://g' | cut -c1-8)
  newhostid="0x${newhostid}"
  echo "$newhostid" > /etc/hostid
  echo "Generated hostid: $newhostid" >&2
fi
