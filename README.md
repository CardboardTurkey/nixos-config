# NixOS config

sudo ./link.sh

# TODO

* Add dunst
* Symlinks for hardware
* Add hints to alacritty
* Script for first boot using [userActivationScript](https://search.nixos.org/options?channel=21.11&show=system.userActivationScripts&from=0&size=50&sort=relevance&type=packages&query=system.userac) or [fetchFromGithub](https://www.reddit.com/r/NixOS/comments/g8c734/comment/fonoh0p/?utm_source=share&utm_medium=web2x&context=3):
	* Grab gitlab repos (need to setup ssh keys)
	* Add dirs to hash table
	* Set wallpaper and lock screen as: https://wallhaven.cc/w/lmjzjr (use https://www.codyhiar.com/blog/how-to-set-desktop-wallpaper-on-nixos/)

Actually apparently I should use a derivation. Wtf are those lol
