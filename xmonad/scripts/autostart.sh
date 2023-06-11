#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.config/xmonad/scripts/set-screen-resolution-in-virtualbox.sh

# Set display setup
autorandr --change

for id in $(xsetwacom --list devices | sed -n -e 's/^.*id: //p' | cut -c1-2);
  do xsetwacom --set $id MapToOutput HEAD-2;
done


(sleep 2; run $HOME/.config/polybar/launch.sh) &

#change your keyboard if you need it 
setxkbmap -layout us -variant altgr-intl -option nodeadkeys 

#cursor active at boot
xsetroot -cursor_name left_ptr &


#Some ways to set your wallpaper besides variety or nitrogen
# feh --bg-fill /usr/share/backgrounds/archlinux/arch-wallpaper.jpg &
# feh --bg-fill /home/luca/Pictures/wallpaper/blue_clean.jpg &
feh --bg-fill /home/luca/Pictures/pxfuel.jpg &
#start the conky to learn the shortcuts
# (conky -c $HOME/.config/xmonad/scripts/system-overview) &

#starting utility applications at boot time
# run variety &
run nm-applet &
run pamac-tray &
run xfce4-power-manager &
numlockx on &
# blueberry-tray &
picom --config $HOME/.config/xmonad/scripts/picom.conf &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
run fusuma -d #gesten 
run owncloud &
# run tuxedo-control-center &

#starting user applications at boot time
#nitrogen --restore &
#run caffeine &
#run vivaldi-stable &
#run firefox &
#run thunar &
#run spotify &
#run owncloud &
#run rambox &
#run atom &

#run telegram-desktop &
#run discord &
#run dropbox &
#run insync start &
#run ckb-next -b &
