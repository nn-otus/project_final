#!/bin/bash
for entry in \
"mac='52:54:00:03:5d:2b' name='router-1' ip='192.168.122.63'" \
"mac='52:54:00:b9:f0:f6' name='router-2' ip='192.168.122.207'" \
"mac='52:54:00:d9:b2:89' name='blnc-1' ip='192.168.122.46'" \
"mac='52:54:00:84:fb:0c' name='blnc-2' ip='192.168.122.4'" \
"mac='52:54:00:9b:f2:2a' name='front-1' ip='192.168.122.122'" \
"mac='52:54:00:0d:1f:39' name='front-2' ip='192.168.122.91'" \
"mac='52:54:00:f6:fe:13' name='back-1' ip='192.168.122.69'" \
"mac='52:54:00:42:bc:45' name='back-2' ip='192.168.122.24'" \
"mac='52:54:00:d3:89:45' name='db-1' ip='192.168.122.57'" \
"mac='52:54:00:32:51:23' name='db-2' ip='192.168.122.200'" \
"mac='52:54:00:1e:85:cc' name='mon-1' ip='192.168.122.217'"
do
  virsh net-update default add ip-dhcp-host "<host $entry/>" --live --config
done

# После выполнения надо перезапустить сеть:
№ virsh net-destroy default && virsh net-start default
# При этом связь с машинами кратковременно прервется
