for vm in $(virsh list --state-shutoff --name); do
    virsh start "$vm"
done
