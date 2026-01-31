#!/bin/bash
VM_NAME="front-1"
# Оставляем пути к данным в Config, но для проекта конфиги берем из текущей папки
DATA_PATH="/media/user/data"
PROJECT_PATH="/media/user/data/Projects/project_libvirt1"

echo "Подготовка диска для $VM_NAME..."
qemu-img create -f qcow2 -b $DATA_PATH/Distr/debian-12-generic-amd64.qcow2 -F qcow2 $DATA_PATH/VM/$VM_NAME.qcow2 10G

echo "Генерация настроек cloud-init..."

# Теперь берем yml из папки проекта
cloud-localds $DATA_PATH/VM/$VM_NAME-seed.iso $PROJECT_PATH/user-data-front.yml --hostname $VM_NAME

echo "Запуск $VM_NAME..."
virt-install \
  --name $VM_NAME \
  --memory 1024 \
  --vcpus 1 \
  --disk path=$DATA_PATH/VM/$VM_NAME.qcow2,format=qcow2 \
  --disk path=$DATA_PATH/VM/$VM_NAME-seed.iso,device=cdrom \
  --import \
  --os-variant debian12 \
  --network network=front-net \
  --noautoconsole
