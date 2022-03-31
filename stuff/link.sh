#!/usr/bin/env bash

set -e
dir=$(pwd)

ln -fs "${dir}/configuration.nix" /etc/nixos/configuration.nix
# Hardware config
# Seems overly complex
ln -fs "${dir}/hardware/$1/extra.nix" "${dir}/hardware-extra.nix"
ln -fs "${dir}/core/$1.nix" "${dir}/core/hardware.nix"
