#!/bin/bash
## 描述:可以对某个用户实施录像，并且回放，可以实施进行教学
## 作者:刘伍
## 联系方式:xiaoli@qq.com
## TEL:13777773695
## 版本:V_1.0
## 注意录制视频时，时间不要太长，不然内存和磁盘占用空间大
read -p "请输入你要录像的用户：" user
##判断用户是否存在，如果不存在则退出
id $user &>/dev/null
if [ $? -ne 0 ]
then
echo "$user不存在"
exit 1
fi
##判断用户是否已经被录像
m_user(){
	path="/home/$user/.bash_profile"
	num=`cat $path |grep '\<script\>' |wc -l`
	if [ $num -eq 1 ]
	then
		echo "$user已经被录像"
		exit
	fi
}
##对用户实施录像
m_mon(){
	path="/home/$user/.bash_profile"
	chattr +a $path
	echo "m_path1=/data/mon/\`date +%F-%H:%M\`.time" >>$path
	echo "m_path2=/data/mon/\`date +%F-%H:%M\`.his" >>$path
	echo "script -t 2>\$m_path1 -a -f -q \$m_path2" >> $path
	echo "正在实施录像....."
	}
##取消录像
m_cancael(){	
	path="/home/$user/.bash_profile"
	chattr -a $path
	sed -i '/\<script\>/{d}' $path
	sed -i '/\<m_path1\>/{d}' $path
	sed -i '/\<m_path2\>/{d}' $path
	sed -i '/\<'$user'\>/{d}' /root/mon_user.txt
	echo "正在实施取消录像....."
	}

read -p "实施录像请按:y 取消录像请按:n 查询被录像用户请按q：" yes
case $yes in
y)
m_user
m_mon
echo "$user" >> /root/mon_user.txt
;;
n)
m_cancael
;;
q)
cat /root/mon_user.txt
;;
*)
echo "error:input error"
exit 1
esac

