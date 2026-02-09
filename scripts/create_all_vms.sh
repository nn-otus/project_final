#!/bin/bash
PROJECT_PATH="/media/user/data/Projects/project_final"
DIST_IMAGE="/media/user/data/Distr/debian-12-generic-amd64.qcow2"
VM_DIR="/media/user/data/VM"
USER_DATA="$PROJECT_PATH/user-data.yml"

# Таблица соответствия: Имя -> {Вторая_сеть, MAC_для_default}
declare -A vms=(
    ["router-1"]="front-net 52:54:00:00:00:fb"
    ["router-2"]="front-net 52:54:00:00:00:fc"
    ["blnc-1"]="front-net 52:54:00:00:00:11"
    ["blnc-2"]="front-net 52:54:00:00:00:12"
    ["front-1"]="front-net 52:54:00:00:00:21"
    ["front-2"]="front-net 52:54:00:00:00:22"
    ["back-1"]="back-net 52:54:00:00:00:31"
    ["back-2"]="back-net 52:54:00:00:00:32"
    ["db-1"]="db-net 52:54:00:00:00:41"
    ["db-2"]="db-net 52:54:00:00:00:42"
    ["mon-1"]="back-net 52:54:00:00:00:51"
)

create_node() {
    NAME=$1
    NET=$2
    MAC=$3
    echo "Creating $NAME with MAC $MAC..."
    
    qemu-img create -f qcow2 -b $DIST_IMAGE -F qcow2 $VM_DIR/$NAME.qcow2 10G
    cloud-localds "$VM_DIR/$NAME-seed.iso" "$USER_DATA" --hostname "$NAME"
    
    virt-install \
      --name "$NAME" \
      --memory 1024 \
      --vcpus 1 \
      --disk path=$VM_DIR/$NAME.qcow2,format=qcow2 \
      --disk path=$VM_DIR/$NAME-seed.iso,device=cdrom \
      --import \
      --os-variant debian12 \
      --network network=default,mac=$MAC \
      --network network=$NET \
      --noautoconsole
}

# Удаляем старое перед запуском (ОСТОРОЖНО!)
# virsh list --all --name | xargs -I {} virsh undefine {} --remove-all-storage

# Основной цикл создания
for name in "router-1" "router-2" "blnc-1" "blnc-2" "front-1" "front-2" "back-1" "back-2" "db-1" "db-2" "mon-1"; do
    # Извлекаем значения из ассоциативного массива
    val=${vms[$name]}
    net=$(echo $val | cut -d' ' -f1)
    mac=$(echo $val | cut -d' ' -f2)
    
    create_node "$name" "$net" "$mac"
done


# Доп. интерфейсы для роутеров (они подключаются к 3 сетям всего)
for r in router-1 router-2; do
  virsh attach-interface --domain $r --type network --source back-net --model virtio --config --live
  virsh attach-interface --domain $r --type network --source db-net --model virtio --config --live
done
