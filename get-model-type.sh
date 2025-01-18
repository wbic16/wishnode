#!/bin/sh
export RPI=`cat /proc/cpuinfo |grep 'Model' |sed 's/^.*: //g'`
echo $RPI
