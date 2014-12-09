#!/bin/sh

set -x

# Adding hostname to /etc/hosts...
IP_ETH0=`ifconfig eth0 | grep inet | cut -d ":" -f 2 | cut -d " " -f 1`
HOST_NAME=
HOST_ALIAS=
cat >> /etc/hosts << EOF

# Host name
$IP_ETH0  $HOST_NAME  $HOST_ALIAS
EOF

