#!/usr/bin/env bash

for file in $(find ./ -type f -a -name '*.nix' -a ! -wholename './core/nord.nix')
do
    sed 's/2e3440/${config.nord0}/gI' -i $file
    sed 's/3b4252/${config.nord1}/gI' -i $file
    sed 's/434c5e/${config.nord2}/gI' -i $file
    sed 's/4c566a/${config.nord3}/gI' -i $file
    sed 's/d8dee9/${config.nord4}/gI' -i $file
    sed 's/e5e9f0/${config.nord5}/gI' -i $file
    sed 's/eceff4/${config.nord6}/gI' -i $file
    sed 's/8fbcbb/${config.nord7}/gI' -i $file
    sed 's/88c0d0/${config.nord8}/gI' -i $file
    sed 's/81a1c1/${config.nord9}/gI' -i $file
    sed 's/5e81ac/${config.nord10}/gI' -i $file
    sed 's/bf616a/${config.nord11}/gI' -i $file
    sed 's/d08770/${config.nord12}/gI' -i $file
    sed 's/ebcb8b/${config.nord13}/gI' -i $file
    sed 's/a3be8c/${config.nord14}/gI' -i $file
    sed 's/b48ead/${config.nord15}/gI' -i $file
done
