#!/bin/bash

# Сначала удалим старые записи, если они есть (чтобы избежать ошибок дублирования)
# Если записей точно нет, этот блок можно пропустить
virsh net-update default delete ip-dhcp-host "$(virsh net-dumpxml default | xmllint --xpath "//host" - 2>/dev/null)" --config --live 2>/dev/null

for entry in \
"mac='52:54:00:00:00:fb' name='router-1' ip='192.168.122.251'" \
"mac='52:54:00:00:00:fc' name='router-2' ip='192.168.122.252'" \
"mac='52:54:00:00:00:11' name='blnc-1' ip='192.168.122.11'" \
"mac='52:54:00:00:00:12' name='blnc-2' ip='192.168.122.12'" \
"mac='52:54:00:00:00:21' name='front-1' ip='192.168.122.21'" \
"mac='52:54:00:00:00:22' name='front-2' ip='192.168.122.22'" \
"mac='52:54:00:00:00:31' name='back-1' ip='192.168.122.31'" \
"mac='52:54:00:00:00:32' name='back-2' ip='192.168.122.32'" \
"mac='52:54:00:00:00:41' name='db-1' ip='192.168.122.41'" \
"mac='52:54:00:00:00:42' name='db-2' ip='192.168.122.42'" \
"mac='52:54:00:00:00:51' name='mon-1' ip='192.168.122.51'"
do
  echo "Adding DHCP lease: $entry"
  virsh net-update default add ip-dhcp-host "<host $entry/>" --live --config
done
