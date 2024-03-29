#!/bin/sh
# based on
# https://github.com/NicholasFeldman/dotfiles/blob/master/polybar/.config/polybar/spotify.sh

main() {
  if ! pgrep -x spotify >/dev/null; then
    echo ""; exit
  fi
  

  cmd="org.freedesktop.DBus.Properties.Get"
  domain="org.mpris.MediaPlayer2"
  path="/org/mpris/MediaPlayer2"

  meta=$(dbus-send --print-reply --dest=${domain}.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:${domain}.Player string:Metadata)

  artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1  | sed "s/\&/+/g")
  album=$(echo "$meta" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1)
  title=$(echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed "s/\&/+/g")

  status=$(playerctl status --player=spotify)
  # status="Paused"

  if [[ "$status" == "Playing" ]];
  then
    playpause=""
  else
    playpause=""
  fi
  

  # echo "%{A1:spotifyctl -q previous &:}  %{A}%{A1:spotifyctl -q playpause &:} $playpause %{A}%{A1:spotifyctl -q next &:}  %{A} $artist- $title"
  echo "%{A1:playerctl previous &:}  %{A}%{A1:playerctl play-pause &:} $playpause %{A}%{A1:playerctl next &:}  %{A} $artist- $title" 
  
  
  # +"${*:-%artist% - %title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed 's/&/\\&/g'
}

main "$@"