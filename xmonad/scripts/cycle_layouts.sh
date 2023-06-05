#!/bin/bashaua

# get the list of connected monitors
monitors=$(xrandr | grep " connected" | cut -d " " -f1)

# turn off each monitor
for monitor in $monitors; do
    xrandr --output $monitor --off
done

if ["$1" == "--default" ]: then
    autorandr docked
else
    autorandr --cycle
fi

xmonad --restart

if xrandr | grep "HDMI2 connected" then
    for id in $(xsetwacom --list devices | sed -n -e 's/^.*id: //p' | cut -c1-2);
    do xsetwacom --set $id MapToOutput HDMI2;
    done
fi
