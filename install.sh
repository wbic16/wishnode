#!/bin/sh
MODEL=`cat /proc/cpuinfo |grep ^Model |sed 's/^.*: //g'`
if [ ! "x$MODEL" = "xRaspberry Pi 5 Model B Rev 1.0" ]; then
  echo "Unexpected $MODEL"
  exit 1
fi
if [ ! "x$USER" = "xroot" ]; then
  echo "Must run as root"
  exit 1
fi
echo "Reconfiguring zram for 12 GB..."
chmod +x init-zram-swapping.sh
cp init-zram-swapping.sh /usr/bin/init-zram-swapping

/usr/bin/init-zram-swapping
