#!/usr/bin/env sh

# More info : https://github.com/jaagr/polybar/wiki

# Install the following applications for polybar and icons in polybar if you are on ArcoLinuxD
# awesome-terminal-fonts
# Tip : There are other interesting fonts that provide icons like nerd-fonts-complete
# --log=error
# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

desktop=$(echo $DESKTOP_SESSION)
count=$(xrandr --query | grep " connected" | cut -d" " -f1 | wc -l)


case $desktop in

    xmonad|/usr/share/xsessions/xmonad)
    if [ $count = 1 ]; then
      m=$(xrandr --query | grep " connected" | cut -d" " -f1)
      MONITOR=$m polybar --reload mainbar-xmonad -c ~/.config/polybar/config &
    else
      k=1
      for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload mainbar-xmonad-$k -c ~/.config/polybar/config &
        k=$((k+1))
      done
    fi

    # MONITOR=DP-2 polybar --reload mainbar-xmonad -c ~/.config/polybar/config &

    # MONITOR=HDMI-1 polybar --reload mainbar-xmonad1 -c ~/.config/polybar/config &

    # MONITOR=HDMI-2 polybar --reload mainbar-xmonad2 -c ~/.config/polybar/config &
          
    # MONITOR=DP-1 polybar --reload mainbar-xmonad3 -c ~/.config/polybar/config &

    # second polybar at bottom
     if [ $count = 1 ]; then
       m=$(xrandr --query | grep " connected" | cut -d" " -f1)
       MONITOR=$m polybar --reload mainbar-xmonad-extra -c ~/.config/polybar/config &
     else
       for m in "DP-1-0.1"; do
         MONITOR=$m polybar --reload mainbar-xmonad-extra -c ~/.config/polybar/config &
       done
     fi
    ;;

esac
