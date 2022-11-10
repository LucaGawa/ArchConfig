#!/bin/sh
#source https://github.com/x70b1/polybar-scripts
#source https://github.com/polybar/polybar-scripts

if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l ); then
    updates_aur=0
fi

echo "%{A1:alacritty -e sudo pacman -Syu &:} $updates_arch %{A}(%{A1:alacritty -e yay &:} $updates_aur %{A})"


