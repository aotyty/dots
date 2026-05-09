#! /bin/bash

# Определение полосы визуализации
bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# Создание "словаря" для замены чисел на символы из 'bar'
i=0
while [ $i -lt ${#bar} ]; do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i = i + 1))
done

# Настройка конфигурации CAVA
config_file="/tmp/polybar_cava_config"
echo "
[general]
bars = 10
sensitivity = 100

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
" >$config_file

# Запуск CAVA и преобразование вывода
cava -p $config_file | while read -r line; do
    echo $line | sed $dict
done
