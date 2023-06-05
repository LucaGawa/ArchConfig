#!/bin/sh

bluetooth_print() {
    if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
then
  echo " 󰂲"
else
  if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
  then 
    echo " 󰂯"
  fi
  devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
  counter=0
  aliases=""
            for device in $devices_paired; do
                device_info=$(bluetoothctl info "$device")
                
                if echo "$device_info" | grep -q "Connected: yes"; then
                    device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)
                    
                    if [ $counter -gt 0 ]; then
                        aliases+=", $device_alias"
                    else
                        aliases+="$device_alias"
                    fi

                    counter=$((counter + 1))
                fi
            done
#   echo "%{F#2193ff} $aliases"
echo "󰂱 $aliases"
fi

}

bluetooth_toggle() {
    printf 'test'
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done
    else
        devices_paired=$(bluetoothctl devices Paired | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_print
        ;;
esac