#!/bin/bash
###############进行修改IP##################
m_name1=`ifconfig |tr -d ":"|awk '/^[a-z]/{print $1}'|head -1`
###############让用户输入IP，并判断是否可用#
read -p "enter your new ip: " m_ip
ping -c1 -W1 $m_ip
if [ $? -eq 0 ]
then
echo "error:$m_ip is in use"
exit
fi
read -p "是否使用$m_ip,y/n: " y
case $y in
y|Y|yes|YES)
cat >/etc/sysconfig/network-scripts/ifcfg-ens33 <<EOF
TYPE=Ethernet
BOOTPROTO=static
NAME=$m_name1
DEVICE=$m_name1
IPADDR=$m_ip
NETMASK=255.255.255.0
GATEWAY=${m_ip%.*}.2
ONBOOT=yes
EOF
ifdown ens33;ifup ens33
;;
*)
echo "error:exit"
exit
esac











