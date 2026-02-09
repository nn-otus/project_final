for vm in $(virsh list --state-running --name); do
    virsh shutdown "$vm"
done

