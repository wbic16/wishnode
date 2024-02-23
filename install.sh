#!/bin/sh
NAME="phextio"
MODEL=`cat /proc/cpuinfo |grep ^Model |sed 's/^.*: //g'`
if [ "x$MODEL" = "xRaspberry Pi 5 Model B Rev 1.0" ]; then
  echo "$MODEL OK"
else
  if [ "x$MODEL" = "xRaspberry Pi 4 Model B Rev 1.4" ]; then
    echo "$MODEL OK"
  else
    echo "Unexpected $MODEL"
    exit 1
  fi
fi
if [ ! "x$USER" = "xroot" ]; then
  echo "Must run as root"
  exit 1
fi
echo "Installing zram-config..."
apt install linux-modules-extra-raspi -y
apt install zram-config -y

echo "Reconfiguring zram for 12 GB..."
chmod +x init-zram-swapping.sh
cp init-zram-swapping.sh /usr/bin/init-zram-swapping

/usr/bin/init-zram-swapping

echo "Installing zfs..."
HAVE_ZFS=`zfs list |grep phextio |wc -l`
if [ "x$HAVE_ZFS" = "x0" ]; then
  apt install zfsutils-linux -y
  zpool create $NAME /dev/sda
  zfs import phextio
fi

echo "Enabling zfs compression..."
zfs set compress=lz4 phextio
zfs list

echo "Restoring default zfs config..."
cp /etc/default/zfs zfs-config.backup
cp zfs-config /etc/default/zfs

if [ "x$HAVE_ZFS" = "x1" ]; then
  echo "Setup Complete."
fi
