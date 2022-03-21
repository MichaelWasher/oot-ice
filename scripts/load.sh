#!/bin/bash
set -eu
 
DDP=$(basename $(ls /ice-driver/*.pkg | head -n1 ))

rm /usr/lib/firmware/updates/intel/ice/ddp/ice.pkg || true
rm /usr/lib/firmware/intel/ice/ddp/ice.pkg || true

mkdir -p /usr/lib/firmware/intel/ice/ddp/
mkdir -p /usr/lib/firmware/updates/intel/ice/ddp/

cp /ice-driver/$DDP /usr/lib/firmware/intel/ice/ddp/
cp /ice-driver/$DDP /usr/lib/firmware/updates/intel/ice/ddp/

ln -s /usr/lib/firmware/intel/ice/ddp/$DDP /usr/lib/firmware/intel/ice/ddp/ice.pkg
ln -s /usr/lib/firmware/updates/intel/ice/ddp/$DDP /usr/lib/firmware/intel/ice/ddp/ice.pkg

# unload in-tree driver
rmmod ice || true

# load out-of-tree driver
insmod /ice-driver/ice.ko

echo "Loaded out-of-tree ICE"
lsmod | grep ice || true


