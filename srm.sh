#!/bin/bash

ls -li | sed '1{d} ' | cat -n
max=`ls -li | sed '1{d}' | wc -l `

echo "---------------------------------------------------"

read -p "输入要删除的文件编号： "  chos

for var in `echo $chos`
do
     if [ $var -gt $max  ] || [ $var -lt 1 ]
     then
         echo  -e "\033[31m ERROR: \033[0m  输入的编号超出范围 ..."
         exit 1
     fi
     fid=`ls -li | sed '1{d}' |  cat -n  | grep -E "^[ ]+\<$var\>" | awk '{print $2}'`
     find . -inum  $fid  -ok  rm {} \;
done
