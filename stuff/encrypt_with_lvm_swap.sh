#!/usr/bin/env sh
[ -z "$1" ] && { echo Provide partition to encrypt; exit 1; }
[ -z "$2" ] && { echo Provide boot partition; exit 1; }
cryptsetup luksFormat "$1"
cryptsetup open "$1" cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg /dev/mapper/cryptlvm
lvcreate -C y -L $(awk '/MemTotal/ { printf "%i\n", $2/1e6 + 3 }' /proc/meminfo)G vg -n swap # RAM size +2GB is recommended for swapsize
lvcreate -l 100%FREE vg -n root
lvreduce -L -256M vg/root # See the tip here https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system#Preparing_the_logical_volumes
mkfs.ext4 /dev/vg/root
mkfs.fat -F 32 -n boot "$2"
mkswap /dev/vg/swap
mount /dev/vg/root /mnt
mkdir /mnt/boot
mount "$2" /mnt/boot
swapon /dev/vg/swap
