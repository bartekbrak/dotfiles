#!/bin/bash
set -x
iface=${1:-$(printf '%s\n' /sys/class/net/*/wireless | awk -F'/' '{ print $5 }')};
awk '{if(l1){printf "%03.0f↓ ↑%03.0f", ($2-l1)/1024, ($10-l2)/1024} else{l1=$2; l2=$10;}}' <(grep $iface /proc/net/dev) <(sleep 1; grep $iface /proc/net/dev) > /tmp/netspeed

