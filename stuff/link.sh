#!/usr/bin/env bash

set -e
dir=$(pwd)

ln -fs "${dir}/configuration.nix" /etc/nixos/configuration.nix
# Hardware config
ln -fs "${dir}/machines/$1/machine-config.nix" "${dir}/machine-config.nix"

