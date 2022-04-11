# NixOS config

sudo ./link.sh

# TODO

* Setup steam desktop and XDG add to path
* Add hints to alacritty
* Script for first boot using [userActivationScript](https://search.nixos.org/options?channel=21.11&show=system.userActivationScripts&from=0&size=50&sort=relevance&type=packages&query=system.userac) or [fetchFromGithub](https://www.reddit.com/r/NixOS/comments/g8c734/comment/fonoh0p/?utm_source=share&utm_medium=web2x&context=3):
	* Grab gitlab repos (need to setup ssh keys)
	* Add dirs to hash table
	* Set wallpaper and lock screen as: https://wallhaven.cc/w/lmjzjr (use https://www.codyhiar.com/blog/how-to-set-desktop-wallpaper-on-nixos/)

Actually apparently I should use a derivation. Wtf are those lol

# Links

* [vim spell check](https://www.adamalbrecht.com/blog/2019/10/21/spell-check-in-vim-for-markdown-and-git-commit-messages/)
* [fprintd off when lid closed](https://unix.stackexchange.com/questions/678609/how-to-disable-fingerprint-authentication-when-laptop-lid-is-closed)
* [debug proton](https://forums.linuxmint.com/viewtopic.php?t=353144)
* [So _THAT'S_ how you add derivations to your config](https://discourse.nixos.org/t/howto-merge-a-derivation-nix-to-etc-nixos-configuration-nix/12797/3)
