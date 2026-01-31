#!/bin/bash
# Пути к ресурсам
DATA_PATH="/media/user/data"
VM_NAME="router-1"

echo "Подготовка диска для $VM_NAME..."
qemu-img create -f qcow2 -b $DATA_PATH/Distr/debian-12-generic-amd64.qcow2 -F qcow2 $DATA_PATH/VM/$VM_NAME.qcow2 10G

echo "Генерация настроек cloud-init..."
cloud-localds $DATA_PATH/VM/$VM_NAME-seed.iso $DATA_PATH/Config/user-data.yml --hostname $VM_NAME

echo "Запуск виртуальной машины..."
virt-install \
  --name $VM_NAME \
  --memory 1024 \
  --vcpus 1 \
  --disk path=$DATA_PATH/VM/$VM_NAME.qcow2,format=qcow2 \
  --disk path=$DATA_PATH/VM/$VM_NAME-seed.iso,device=cdrom \
  --import \
  --os-variant debian12 \
  --network network=default \
  --noautoconsole
