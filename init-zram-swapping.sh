#!/bin/sh
# Raspberry Pi 5 has 8 GB RAM
# Enable 12 GB swap to maximize RAM workloads
GB=12
HAVE_ZRAM=`lsmod |grep zram |wc -l`
if [ ! $HAVE_ZRAM = 0 ]; then
  swapoff /dev/zram0
  rmmod zram
fi
modprobe zram

# 8 GB RAM + 12 GB swap
mem=12884901888
echo "Allocated 12 GB"

# initialize the devices
echo $mem > /sys/block/zram0/disksize
mkswap -fq /dev/zram0
swapon -p 5 /dev/zram0
