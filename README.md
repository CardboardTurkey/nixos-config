# NixOS config

## Setup

`sudo ./link.sh MACHINE_NAME`

### Pi

Can use sean's image because it already has a swap space applied. Remember to update channel first.

## Get partition UUID

`ls -l /dev/disk/by-uuid`

# TODO

* Setup steam desktop and XDG add to path
* Make dirtygit a rust daemon
* Add hints to alacritty
* Script for first boot using [userActivationScript](https://search.nixos.org/options?channel=21.11&show=system.userActivationScripts&from=0&size=50&sort=relevance&type=packages&query=system.userac) or [fetchFromGithub](https://www.reddit.com/r/NixOS/comments/g8c734/comment/fonoh0p/?utm_source=share&utm_medium=web2x&context=3):
	* Grab gitlab repos (need to setup ssh keys)
	* Add dirs to hash table
* Breakup misc and boring stuff
* Add ssh method to initial pi

# Links

* [vim spell check](https://www.adamalbrecht.com/blog/2019/10/21/spell-check-in-vim-for-markdown-and-git-commit-messages/)
* [fprintd off when lid closed](https://unix.stackexchange.com/questions/678609/how-to-disable-fingerprint-authentication-when-laptop-lid-is-closed)
* [debug proton](https://forums.linuxmint.com/viewtopic.php?t=353144)
* [So _THAT'S_ how you add derivations to your config](https://discourse.nixos.org/t/howto-merge-a-derivation-nix-to-etc-nixos-configuration-nix/12797/3)
* [Encryption guide](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)

# Wallpapers

1. https://w.wallhaven.cc/full/lm/wallhaven-lmjzjr.jpg
2. https://nordthemewallpapers.com/Backgrounds/All/img/minimal-22-nordified.jpg
3. https://nordthemewallpapers.com/Backgrounds/All/img/spacemars.jpg
