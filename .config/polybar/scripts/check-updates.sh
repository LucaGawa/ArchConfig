#!/bin/sh
#source https://github.com/x70b1/polybar-scripts
#source https://github.com/polybar/polybar-scripts

if ! updates_arch=$(checkupdates 0> /dev/null | wc -l ); then
    updates_arch=0
fi

if ! updates_aur=$(yay -Qum 0> /dev/null | wc -l ); then
    updates_aur=0
fi

# updates_arch=0
if [ $updates_arch -gt 0 ]; then
    echo "%{A1:alacritty -e sudo pacman -Syu &:} $updates_arch %{A}(%{A1:alacritty -e yay &:} $updates_aur %{A})"
else
    echo ""
fi


# pacman -Qu