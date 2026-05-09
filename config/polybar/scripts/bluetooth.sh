#!/bin/bash

# Получаем список адаптеров
ADAPTERS=$(bluetoothctl list 2>/dev/null | grep -o '..:..:..:..:..:..')

# Если нет адаптера - выходим
if [ -z "$ADAPTERS" ]; then
    dunstify -u critical -i bluetooth "Bluetooth" "Адаптер не найден"
    exit 1
fi

# Проверяем статус первого адаптера
STATUS=$(bluetoothctl show $ADAPTERS 2>/dev/null | grep "Powered:" | awk '{print $2}')

if [ "$1" = "toggle" ]; then
    # Только переключение
    if [ "$STATUS" = "yes" ]; then
        bluetoothctl power off >/dev/null 2>&1
        dunstify -u low -i bluetooth "Bluetooth Power Off" -t 1500
    else
        bluetoothctl power on >/dev/null 2>&1
        dunstify -u low -i bluetooth "Bluetooth Power On" -t 1500
    fi
elif [ "$1" = "status" ]; then
    # Только вывод статуса
    if [ -z "$STATUS" ]; then
        echo "󰂲"
    elif [ "$STATUS" = "yes" ]; then
        echo "󰂯"
    else
        echo "󰂲"
    fi
else
    # Если аргумент не передан - показываем справку
    echo "Использование: $0 {toggle|status}"
fi
