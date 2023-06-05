#!/bin/sh

check_updates(){
    if ! updates_arch=$(checkupdates 0> /dev/null | wc -l ); then
        updates_arch=0
    fi

    # if ! updates_aur=$(yay -Qum 0> /dev/null | wc -l ); then
    #     updates_aur=0
    # fi
    updates_aur=0

    updates=$(($updates_arch+$updates_aur))

    # if [ $updates_arch -gt 0 ]; then
    echo "$updates"
    # sudo pacman -Syu --noconfirm
    # fi
}

download_updates(){
    kill check_updates
    echo "test"
    sudo pacman -Syu --noconfirm
    printf "test2"
    # cat ~/.config/polybar/scripts/check-updates.sh
    # $test=10
    # echo "uppy dappy"

}



# pacman -Qu

case "$1" in
    --download)
        download_updates
        ;;
    *)
        check_updates
        ;;
esac