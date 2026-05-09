#!/bin/bash

# Функция для отправки уведомления
send_brightness_notification() {
    local brightness=$(brightnessctl g)
    local max=$(brightnessctl m)
    local percent=$((brightness * 100 / max))

    if [ "$percent" -le 50 ]; then
        dunstify -u low -r 667 -h int:value:$percent -i "/usr/share/icons/Gruvbox-Plus-Dark/actions/16/brightness-low.svg" -a "Brightness" \
            "" -t 1000 -h string:hlcolor:"#ebdbb2"
    else
        dunstify -u low -r 667 \
            -h int:value:"$percent" \
            -h string:hlcolor:"#ebdbb2" \
            -i "/usr/share/icons/Gruvbox-Plus-Dark/actions/16/brightness-high.svg" \
            -a "Brightness" \
            -t 1000 \
            " " " "
    fi
}

case "$1" in
up)
    brightnessctl set +1%
    send_brightness_notification
    ;;
down)
    brightnessctl --min-value=1 set 1%-
    send_brightness_notification
    ;;
*)
    echo "Использование: $0 {up|down}"
    ;;
esac
