#!/bin/bash

# Функция для получения процента сигнала WiFi
get_wifi_strength() {
    local interface=$1
    local signal=$(iwconfig $interface 2>/dev/null | grep -o 'Signal level=[-0-9]*' | cut -d'=' -f2)

    if [ -n "$signal" ]; then
        signal=${signal#-}
        if [ $signal -lt 20 ]; then
            echo "0"
        elif [ $signal -lt 35 ]; then
            echo "25"
        elif [ $signal -lt 50 ]; then
            echo "50"
        elif [ $signal -lt 65 ]; then
            echo "75"
        else
            echo "100"
        fi
    else
        echo "0"
    fi
}

# Функция для получения имени WiFi сети
get_wifi_ssid() {
    local interface=$1
    iwconfig $interface 2>/dev/null | grep -o 'ESSID:"[^"]*"' | cut -d'"' -f2
}

# Поиск интерфейсов (исправлено)
WIFI_INTERFACE=$(iwconfig 2>/dev/null | grep -o '^[a-zA-Z0-9]*' | head -1)
ETH_INTERFACE=$(ip link show | grep -oE 'enp[a-z0-9]+|ens[a-z0-9]+|eth[0-9]+' | head -1)

# Если не нашли ethernet по новым именам, ищем любой не-wifi интерфейс
if [ -z "$ETH_INTERFACE" ]; then
    ETH_INTERFACE=$(ip link show | grep -v 'lo:\|wl\|wlp' | grep -oE '^[0-9]+: [a-zA-Z0-9]+' | cut -d' ' -f2 | head -1)
fi

# Проверяем Ethernet
if [ -n "$ETH_INTERFACE" ]; then
    if ip addr show $ETH_INTERFACE 2>/dev/null | grep -q "inet "; then
        echo "󰈀 "
        exit 0
    fi
fi

# Проверяем WiFi
if [ -n "$WIFI_INTERFACE" ]; then
    if iwconfig $WIFI_INTERFACE 2>/dev/null | grep -q "ESSID:\"[^\"]\+\""; then
        STRENGTH=$(get_wifi_strength $WIFI_INTERFACE)
        SSID=$(get_wifi_ssid $WIFI_INTERFACE)

        if [ $STRENGTH -ge 75 ]; then
            ICON="󰤨 "
        elif [ $STRENGTH -ge 50 ]; then
            ICON="󰤥 "
        elif [ $STRENGTH -ge 25 ]; then
            ICON="󰤢 "
        elif [ $STRENGTH -gt 0 ]; then
            ICON="󰤟 "
        else
            ICON="󰤯 "
        fi

        if [ -n "$SSID" ] && [ "$SSID" != "off/any" ]; then
            echo "$ICON"
        else
            echo "$ICON"
        fi
        exit 0
    fi
fi

# Нет соединения
echo "󰤮 "
