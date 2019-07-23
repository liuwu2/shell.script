#!/bin/bash
##########适合CentOS7###########
#双网卡绑定
net="/etc/sysconfig/network-scripts"
#########列出当前有多少网卡###############################
m_name=`ip a |tr -d ":"|grep -v "lo"|awk '/^[0-9]/{print $2}'`
echo "你目前的网卡有：
$m_name"
##########让用户输入网卡和IP并判断网卡是否正确#############
read -p "请输入第一个网卡名称：" m_name1
m_n=`ip a|tr -d ":"|grep "^[0-9]"|grep -v "lo" |awk '$2~/\<'$m_name1'\>/{print $2}'|wc -l`
if [ $m_n -ne 1 ]
then
echo "error"
exit 1
fi

read -p "请输入第二个网卡名称：" m_name2
m_e=`ip a|tr -d ":"|grep "^[0-9]"|grep -v "lo" |awk '$2~/\<'$m_name2'\>/{print $2}'|wc -l`
if [ $m_n -ne 1 ] || [ "$m_name1" = "$m_name2" ]
then
echo "error"
exit 1
fi

read -p "请输入需要配置的IP：" m_ip
ping -c1 -W1 $m_ip
if [ $? -eq 0 ]
then
echo "error"
exit 1
fi
##########让用户在次确定#########################
cat <<EOF
请确定你的网卡是否正确
网卡1：$m_name1
网卡2：$m_name2
IP：$m_ip
EOF
read -p "是否确定y/n: " y
#################当再次确定时进行双网卡绑定#####################
case $y in
y|Y)
ifdown bond0
ifdown $m_name1
ifdown $m_name2
cat > $net/ifcfg-bond0 <<EOF
TYPE=Ethernet
BOOTPROTO=static
NAME=bond0
DEVICE=bond0
IPADDR=$m_ip
NETMASK=255.255.255.0
GATEWAY=${m_ip%.*}.2
ONBOOT=yes
BONDING_OPTS="miimon=100 mode=6"
EOF
cat > $net/ifcfg-$m_name1 <<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=$m_name1
DEVICE=$m_name1
MASTER=bond0
SLAVE=yes
EOF
cat > $net/ifcfg-$m_name2 <<EOF
TYPE=Ethernet
BOOTPROTO=none
NAME=$m_name2
DEVICE=$m_name2
MASTER=bond0
SLAVE=yes
EOF
service network restart
;;
*)
exit

esac
