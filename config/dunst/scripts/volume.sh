#!/bin/bash

send_volume_notification() {
    local volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1)
    local muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

    if [ "$muted" = "yes" ]; then
        dunstify -u low -r 666 \
            -h int:value:$volume \
            -h int:max:100 \
            -h string:hlcolor:"#ebdbb2" \
            -i "/usr/share/icons/Gruvbox-Plus-Dark/actions/16/audio-volume-muted.svg" \
            -a "Volume" \
            "" -t 1000
    else
        # Выбираем иконку
        if [ $volume -le 30 ]; then
            dunstify -u low -r 666 \
                -h int:value:$volume \
                -h int:max:100 \
                -h string:hlcolor:"#ebdbb2" \
                -i "/usr/share/icons/Gruvbox-Plus-Dark/actions/16/audio-volume-low.svg" \
                -a "Volume" \
                "" -t 1000
        elif [ $volume -le 70 ]; then
            dunstify -u low -r 666 \
                -h int:value:$volume \
                -h int:max:100 \
                -h string:hlcolor:"#ebdbb2" \
                -i "/usr/share/icons/Gruvbox-Plus-Dark/actions/16/audio-volume-medium.svg" \
                -a "Volume" \
                "" -t 1000
        else
            dunstify -u low -r 666 \
                -h int:value:$volume \
                -h int:max:100 \
                -h string:hlcolor:"#ebdbb2" \
                -i "/usr/share/icons/Gruvbox-Plus-Dark/actions/16/audio-volume-high.svg" \
                -a "Volume" \
                "" -t 1000
        fi

    fi
}

case "$1" in
up)
    pactl set-sink-volume @DEFAULT_SINK@ +5%
    send_volume_notification
    ;;
down)
    pactl set-sink-volume @DEFAULT_SINK@ -5%
    send_volume_notification
    ;;
mute)
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    send_volume_notification
    ;;
esac

canberra-gtk-play -i audio-volume-change -d "changeVolume" 2>/dev/null
