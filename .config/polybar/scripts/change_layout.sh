#!/bin/bash
current_layout=$(setxkbmap -query | grep layout | cut -c13-)
layout_print(){
echo $current_layout
}

layout_toggle() {
if [[ $current_layout = *de* ]];then
    echo "test"
    setxkbmap -layout us -variant altgr-intl -option nodeadkeys
    current_layout="us"
else

    setxkbmap -layout de
    current_layout="de"
fi
}

case "$1" in
    --toggle)
        layout_toggle
        ;;
    *)
        layout_print
        ;;
esac