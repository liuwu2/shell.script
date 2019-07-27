#!/bin/bash
#删除文件脚本
m_list=`ls -li|sed '1{d}'|cat -n`
m_wc=`ls -li|sed '1{d}'|cat -n|wc -l`
echo "$m_list"
read -p "请输入需要删除文件和目录的编号：" m_num  
[ -z $m_num ] && exit
if [[ ! "$m_num" =~ ^[0-9] ]] || [ $m_num -gt $m_wc ]||[ $m_num -lt 1 ]
then
exit
fi
m_nu=`ls -li|sed '1{d}'|cat -n|awk  ''$m_num'==$1{print $2}'`
read -p "按y删除,按任意键退出：" m_select
case $m_select in
y)
find . -inum $m_nu -exec rm -rf {} \;  &>/dev/null
echo "文件和目录已删除"
;;
*)
exit 1
esac
