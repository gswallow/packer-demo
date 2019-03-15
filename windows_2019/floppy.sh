#!/bin/bash

# This isn't automatable without sudo
# Make sure dosfstools is installed

dd if=/dev/zero of=win2019boot.img bs=1024 count=1440
mkfs.vfat -n BOOT win2019boot.img
TEMPDIR=$(mktemp -d)
sudo mount -o user,loop -t vfat win2019boot.img $TEMPDIR
sudo cp files/vsphere/Autounattend.xml $TEMPDIR
sudo umount $TEMPDIR
rmdir $TEMPDIR
