#!/bin/bash
read -p "please input network: " network		#请输入网卡名称
ifup $network						#开启网卡
sleep 10						#休眠10秒

ip=`ifconfig |awk '/inet/{print $2}'|head -1`		#截取动态IP
netmask=`ifconfig |awk '/inet/{print $4}'|head -1`	#截取掩码
gateway=`route | awk '/ens33/{print $3}'|tail -1`	#截取网关
path=/etc/sysconfig/network-scripts/ifcfg-$variable		#定义路径
cp $path /etc/sysconfig/network-scripts/ifcfg-$variable.bf	#备份要改的文件

sed -i 's/ONBOOT=no/ONBOOT=yes/' $path				
sed -i 's/BOOTPROTO=dhcp/BOOTPROTO=static/' $path
sed -i '$a IPADDR='$ip $path
sed -i '$a NETMASK='$netmask $path
sed -i '$a GATEWAY='$gateway $path

systemctl restart network
