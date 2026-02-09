#!/bin/bash

# Создаем папки, если их еще нет
mkdir -p config scripts

# Перемещаем скрипты и конфиги (скрывая ошибки, если файлы уже перемещены)
mv *.sh scripts/ 2>/dev/null
mv *.xml *.cfg user-data.yml config/ 2>/dev/null

# Массовая правка путей внутри скриптов
# Ищем упоминания .xml и user-data.yml и добавляем префикс config/
sed -i 's/\([a-z_-]*\.xml\)/config\/\1/g' scripts/*.sh
sed -i 's/user-data\.yml/config\/user-data.yml/g' scripts/*.sh

echo "Реорганизация завершена. Проверьте содержимое папок config/ и scripts/"
