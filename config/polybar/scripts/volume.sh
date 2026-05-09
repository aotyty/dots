#!/bin/bash

# Функция для получения процента громкости
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+(?=%)' | head -1
}

# Функция для проверки mute
is_muted() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"
}

# Функция для получения имени Bluetooth-устройства
get_bluetooth_device() {
    # Получаем имя активного Bluetooth-устройства через pactl
    local sink_name=$(pactl info | grep "Default Sink" | cut -d' ' -f3)

    # Если это bluetooth устройство
    if echo "$sink_name" | grep -qi "bluez"; then
        # Пытаемся извлечь имя из описания
        local device_desc=$(pactl list sinks | grep -A 20 "Name: $sink_name" | grep "Description:" | head -1 | cut -d':' -f2- | sed 's/^ //')

        if [ -n "$device_desc" ]; then
            # Сокращаем название если слишком длинное
            if [ ${#device_desc} -gt 20 ]; then
                echo "${device_desc:0:17}..."
            else
                echo "$device_desc"
            fi
            return 0
        fi
    fi

    # Альтернативный способ через bluetoothctl
    if command -v bluetoothctl &>/dev/null; then
        # Находим MAC подключённого устройства
        local connected_mac=$(bluetoothctl devices | while read line; do
            mac=$(echo "$line" | awk '{print $2}')
            if bluetoothctl info "$mac" 2>/dev/null | grep -q "Connected: yes"; then
                echo "$mac"
                break
            fi
        done)

        if [ -n "$connected_mac" ]; then
            local device_name=$(bluetoothctl info "$connected_mac" 2>/dev/null | grep "Name:" | cut -d' ' -f2-)
            if [ -n "$device_name" ]; then
                echo "$device_name"
                return 0
            fi
        fi
    fi

    return 1
}

# Функция для получения типа устройства вывода
get_sink_type() {
    local sink_name=$(pactl info | grep "Default Sink" | cut -d' ' -f3)
    if echo "$sink_name" | grep -qi "bluez"; then
        echo "bluetooth"
    else
        echo "normal"
    fi
}

# Основная логика
VOLUME=$(get_volume)
SINK_TYPE=$(get_sink_type)

# Проверяем mute
if is_muted; then
    echo "󰝟 muted"
    exit 0
fi

# Если Bluetooth
if [ "$SINK_TYPE" = "bluetooth" ]; then
    DEVICE=$(get_bluetooth_device)
    if [ -n "$DEVICE" ]; then
        # Выбираем иконку по громкости
        if [ $VOLUME -lt 30 ]; then
            echo "󰂯 $VOLUME%"
        elif [ $VOLUME -lt 70 ]; then
            echo "󰂰 $VOLUME"
        else
            echo "󰂱 $VOLUME%"
        fi
    else
        # Bluetooth но имя не найдено
        if [ $VOLUME -lt 30 ]; then
            echo "󰂯 $VOLUME%"
        elif [ $VOLUME -lt 70 ]; then
            echo "󰂰 $VOLUME%"
        else
            echo "󰂱 $VOLUME%"
        fi
    fi
else
    # Обычный звук
    if [ $VOLUME -lt 30 ]; then
        echo "󰖀 $VOLUME%"
    elif [ $VOLUME -lt 70 ]; then
        echo "󰕾 $VOLUME%"
    else
        echo "󰕾 $VOLUME%"
    fi
fi
