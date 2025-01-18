#!/bin/bash
source wn-version >/dev/null
source get-model-type.sh >/dev/null
source get-ram-stats.sh >/dev/null
source get-disk-size.sh >/dev/null
echo "----------------"
echo "Wish Node v$WN_VERSION"
echo "----------------"
echo "Model: $RPI"
echo "Disk: $DISK_SIZE"
echo "RAM: $((($FREE_MB+512)/1024)) GB"
