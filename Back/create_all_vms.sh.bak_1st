#!/bin/bash
PROJECT_PATH="/media/user/data/Projects/project_final"
DIST_IMAGE="/media/user/data/Distr/debian-12-generic-amd64.qcow2"
VM_DIR="/media/user/data/VM"
USER_DATA="$PROJECT_PATH/user-data.yml"

create_node() {
    NAME=$1
    NET=$2
    echo "Creating $NAME..."
    
    # Клонируем диск
    qemu-img create -f qcow2 -b $DIST_IMAGE -F qcow2 $VM_DIR/$NAME.qcow2 10G
    
    # Seed ISO (имя хоста совпадает с именем машины)
    # cloud-localds $VM_DIR/$NAME-seed.iso $PROJECT_PATH/$USER_DATA --hostname $NAME
    cloud-localds "$VM_DIR/$NAME-seed.iso" "$USER_DATA" --hostname "$NAME"
    
    # Установка
    virt-install \
      --name "$NAME" \
      --memory 1024 \
      --vcpus 1 \
      --disk path=$VM_DIR/$NAME.qcow2,format=qcow2 \
      --disk path=$VM_DIR/$NAME-seed.iso,device=cdrom \
      --import \
      --os-variant debian12 \
      --network network=default \
      --network network=$NET \
      --noautoconsole
}

# Старт
# Балансировщики
create_node blnc-1 front-net
create_node blnc-2 front-net

# Роутеры
create_node router-1 front-net
create_node router-2 front-net

# Фронты
create_node front-1 front-net
create_node front-2 front-net

# Бэкенды
create_node back-1 back-net
create_node back-2 back-net

# Базы
create_node db-1 db-net
create_node db-2 db-net

# Мониторинг
create_node mon-1 back-net

# Добавляем сети маршрутизаторам
for r in router-1 router-2; do
  virsh attach-interface --domain $r --type network --source back-net --model virtio --config --live
  virsh attach-interface --domain $r --type network --source db-net --model virtio --config --live
done
