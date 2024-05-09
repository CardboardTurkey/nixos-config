# NixOS config

## Setup

`sudo ./link.sh MACHINE_NAME`

Don't forget `sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos`.

### First boot

* Edit link.sh to append `/mnt`
* Set root uuid in core using `ls -l /dev/disk/by-uuid`
* Enable yubikey with `pamu2cfg > ~/.config/Yubico/u2f_keys`
* Add second with `pamu2cfg -n >> ~/.config/Yubico/u2f_keys`
* Then scrap your password: `sudo passwd -d kiran`

### Partitioning

#### Windows dual boot

Use the same EFI parition as Windows. You can expand it (and move the neighbours) using gparted.

#### Encryption

Create a single parition. Encrypt it. Then LVM it to create root and swap.

Create the single parition using gparted. I used lvm name and label but I dont think it matters.

This parition ended up being called /dev/nvme0n1p5. This is what I did after:

```shell
cryptsetup luksFormat /dev/nvme0n1p5
cryptsetup open /dev/nvme0n1p5 cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg /dev/mapper/cryptlvm
lvcreate -C -L 40G vg -n swap # RAM size +2GB is recommended for swapsize
lvcreate -C y -L 40G vg -n swap
lvcreate -l 100%FREE vg -n root
lvreduce -L -256M vg/root # See the tip here https://wiki.archlinux.org/title/dm-crypt/Encrypting_an_entire_system#Preparing_the_logical_volumes
mkfs.ext4 /dev/vg/root
mkswap /dev/vg/swap
mount /dev/vg/root /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
swapon /dev/vg/swap
```

Follow nixos [guide] for setting up boot and swap partition. Use [lvm] for the
root partition though (`parted /dev/sda -- mkpart lvm 512MB -8GB` seems to
work).

In principle you could also use lvm (with the `-C` flag for contiguous) for the
swap parition but apparently it doesn't make much difference:
<https://unix.stackexchange.com/a/144597>

[guide]: https://nixos.org/manual/nixos/stable/#sec-installation-manual
[lvm]: https://linuxhandbook.com/lvm-guide/

### Annoyances

Wallpapers need to be copied across. Git repos need to be reinstantiated.

Need to enable touch detector `systemctl --user enable yubikey-touch-detector.service`

Enabling notifications on firefox websites.

Update root partition uuid `ls -l /dev/disk/by-uuid`.

### Pi

Can use sean's image because it already has a swap space applied. Remember to update channel first.


## TODO

* steal sean's power management
* Switch to flakes and use hyprlock

## Links

* [vim spell check](https://www.adamalbrecht.com/blog/2019/10/21/spell-check-in-vim-for-markdown-and-git-commit-messages/)
* [fprintd off when lid closed](https://unix.stackexchange.com/questions/678609/how-to-disable-fingerprint-authentication-when-laptop-lid-is-closed)
* [debug proton](https://forums.linuxmint.com/viewtopic.php?t=353144)
* [So _THAT'S_ how you add derivations to your config](https://discourse.nixos.org/t/howto-merge-a-derivation-nix-to-etc-nixos-configuration-nix/12797/3)
* [Encryption guide](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)

## Wallpapers

1. <https://w.wallhaven.cc/full/lm/wallhaven-lmjzjr.jpg>
1. <https://nordthemewallpapers.com/Backgrounds/All/img/minimal-22-nordified.jpg>
1. <https://nordthemewallpapers.com/Backgrounds/All/img/spacemars.jpg>
1. <https://wallhaven.cc/w/mdrv1y>

## Setting up proton mail

* <https://proton.me/support/custom-domain>

## Components

* digikey
* farnell
* mouser
