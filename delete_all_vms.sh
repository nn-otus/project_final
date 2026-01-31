# Останавливаем и удаляем регистрацию всех машин
for vm in $(virsh list --all --name); do
    virsh destroy $vm 2>/dev/null
    virsh undefine $vm --remove-all-storage 2>/dev/null
done

# Удаляем оставшиеся файлы дисков и ISO вручную (на всякий случай)
rm -f /media/user/data/VM/*.qcow2
rm -f /media/user/data/VM/*.iso

# Исправляем права на папку, чтобы qemu-img не ругался на Permission denied
sudo chown -R $(whoami):$(whoami) /media/user/data/VM
sudo chmod -R 775 /media/user/data/VM
sudo setfacl -R -m u:libvirt-qemu:rwx /media/user/data/VM

