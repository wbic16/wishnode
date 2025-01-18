#!/bin/bash
export FREE_MB=`free -m |awk '/^Mem:/{print $2}'`
echo "RAM: $FREE_MB MB"
