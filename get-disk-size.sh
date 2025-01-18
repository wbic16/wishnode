#!/bin/bash
export DISK_SIZE=`lsblk |grep 'sd\|mmc' |head -1 |awk '{print $4}'`
echo "Disk Space: $DISK_SIZE"
