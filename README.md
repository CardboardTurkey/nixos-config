# NixOS config

## Setup

`sudo ./link.sh MACHINE_NAME`

Don't forget `sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos`.

### First boot

* Edit link.sh to append `/mnt`
* Remove projects or get key in
* Set root uuid in core using `ls -l /dev/disk/by-uuid`

### Pi

Can use sean's image because it already has a swap space applied. Remember to update channel first.

### Get partition UUID

`ls -l /dev/disk/by-uuid`

# TODO

* Add hints to alacritty
* switch to wayland
* move autorandr out of hm
* steal sean's power management

# Links

* [vim spell check](https://www.adamalbrecht.com/blog/2019/10/21/spell-check-in-vim-for-markdown-and-git-commit-messages/)
* [fprintd off when lid closed](https://unix.stackexchange.com/questions/678609/how-to-disable-fingerprint-authentication-when-laptop-lid-is-closed)
* [debug proton](https://forums.linuxmint.com/viewtopic.php?t=353144)
* [So _THAT'S_ how you add derivations to your config](https://discourse.nixos.org/t/howto-merge-a-derivation-nix-to-etc-nixos-configuration-nix/12797/3)
* [Encryption guide](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)

# Wallpapers

1. https://w.wallhaven.cc/full/lm/wallhaven-lmjzjr.jpg
1. https://nordthemewallpapers.com/Backgrounds/All/img/minimal-22-nordified.jpg
1. https://nordthemewallpapers.com/Backgrounds/All/img/spacemars.jpg
1. https://wallhaven.cc/w/mdrv1y

# Setting up proton mail:

* https://proton.me/support/custom-domain
