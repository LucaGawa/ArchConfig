#!/bin/bash
current_layout= setxkbmap -query | grep layout 
echo $current_layout
if [[ "$current_layout" != "de" ]];then
    setxkbmap -layout de
    current_layout="de"
else
    setxkbmap -layout us -variant altgr-intl -option nodeadkeys
    current_layout="us"
fi


# echo "$current_layout"