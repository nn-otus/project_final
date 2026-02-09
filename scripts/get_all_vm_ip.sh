for vm in $(virsh list --name); do
  ip=$(virsh domifaddr $vm | grep ipv4 | awk '{print $4}' | cut -d/ -f1)
  echo "$vm: $ip"
done
