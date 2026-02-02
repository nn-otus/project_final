#!/bin/bash
#Использование:
#Остановить ВМ: virsh list --name | xargs -I {} virsh destroy {} (или аккуратно через shutdown).
# Запустить скрипт dhcp_reserv_set.sh (резервирует MAC-адреса в DHCP)
# Запустить этот скрипт со сменой MAC (этот).
# Перезапустить сеть
# virsh net-destroy default
# virsh net-start default




# Ассоциативный массив: имя_вм => новый_mac
declare -A vms=(
    ["router-1"]="52:54:00:00:00:01"
    ["router-2"]="52:54:00:00:00:02"
    ["blnc-1"]="52:54:00:00:00:11"
    ["blnc-2"]="52:54:00:00:00:12"
    ["front-1"]="52:54:00:00:00:21"
    ["front-2"]="52:54:00:00:00:22"
    ["back-1"]="52:54:00:00:00:31"
    ["back-2"]="52:54:00:00:00:32"
    ["db-1"]="52:54:00:00:00:41"
    ["db-2"]="52:54:00:00:00:42"
    ["mon-1"]="52:54:00:00:00:51"
)

for vm in "${!vms[@]}"; do
    new_mac="${vms[$vm]}"
    echo "Updating MAC for $vm to $new_mac..."
    
    # Дампим XML, меняем первую строку с <mac address=.../> и загружаем обратно
    virsh dumpxml "$vm" | \
    sed "0,/<mac address='.*'\/>/s/<mac address='.*'\/>/<mac address='$new_mac'\/>/" | \
    virsh define /dev/stdin
done
