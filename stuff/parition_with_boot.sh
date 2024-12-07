#!/usr/bin/env sh
[ -z "$1" ] && { echo Provide disk; exit 1; }
parted "$1" -- mklabel gpt
parted "$1" -- mkpart lvm ext4 512MB 100%
parted "$1" -- mkpart ESP fat32 1MB 512MB
parted "$1" -- set 2 esp on
