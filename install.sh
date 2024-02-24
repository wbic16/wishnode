#!/bin/sh
EXPECTED="2024-02-23"
NAME="phextio"
MODEL=`cat /proc/cpuinfo |grep ^Model |sed 's/^.*: //g'`
MODEL_OK=0
if [ "x$MODEL" = "xRaspberry Pi 5 Model B Rev 1.0" ]; then
  MODEL_OK=1
fi
if [ "x$MODEL" = "xRaspberry Pi 4 Model B Rev 1.4" ]; then
  MODEL_OK=1
fi
if [ "x$MODEL" = "xRaspberry Pi 4 Model B Rev 1.5" ]; then
  MODEL_OK=1
fi
if [ "x$MODEL" = "x0" ]; then
  echo "Unexpected $MODEL"
  exit 1
fi
echo "$MODEL OK"
if [ ! "x$USER" = "xroot" ]; then
  echo "Must run as root"
  exit 1
fi
VERSION=`cat /etc/phextio/version`
if [ "x$VERSION" = "x$EXPECTED" ]; then
  echo "phextio $VERSION OK"
  exit 0
fi

echo "Updating apt environment..."
apt update
apt upgrade -y

echo "Installing raspi tooling..."
apt install raspi-config -y

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
  zpool create $NAME /dev/sda -f
  zpool import phextio
fi

echo "Enabling zfs compression..."
zfs set compress=lz4 phextio
zfs list

echo "Restoring default zfs config..."
cp /etc/default/zfs zfs-config.backup
cp zfs-config /etc/default/zfs

echo "Deploying microk8s..."
snap install microk8s --classic

echo "Deploying avahi..."
snap install avahi
cp phextio.service /etc/avahi/services/
service avahi-daemon restart

mkdir /etc/phextio
echo -n $EXPECTED >/etc/phextio/version

echo "Setup Complete."
