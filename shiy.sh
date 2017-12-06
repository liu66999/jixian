#!/bin/bash


ipadd=`ifconfig -a | grep broadcast | awk -F "[ :]+" '{print $3}'`
echo "******			linux基线检查脚本	  	     		*****
*************************************************************************************
*****				linux基线配置规范设计				*****
*****				                  					*****
*************************************************************************************" >> /tmp/${ipadd}_out.txt

echo "**********************" >> /tmp/${ipadd}_out.txt
echo "账号策略检查" >>/tmp/${ipadd}_out.txt
echo "**********************" >>/tmp/${ipadd}_out.txt

passmax=`cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}'`
passage=`cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}'`
passlen=`cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}'`
passmin=`cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}'`

if [ $passmax -le 90 -a $passmax -gt 0 ];then
  echo "口令生存周期为${passmax}天，符合要求" >> /tmp/${ipadd}_out.txt
else
  echo "口令生存周期为${passmax}天，不符合要求,建议设置不大于90天" >> /tmp/${ipadd}_out.txt
fi

if [ $passmin -ge 6 ];then
  echo "口令更改最小时间间隔为${passmin}天，符合要求" >> /tmp/${ipadd}_out.txt
else
  echo "口令更改最小时间间隔为${passmin}天，不符合要求，建议设置大于等于6天" >> /tmp/${ipadd}_out.txt
fi

if [ $passlen -ge 8 ];then
  echo "口令最小长度为${passlen},符合要求" >> /tmp/${ipadd}_out.txt
else
  echo "口令最小长度为${passlen},不符合要求，建议设置最小长度大于等于8" >> /tmp/${ipadd}_out.txt
fi

if [ $passage -ge 30 -a $passage -lt $passmax ];then
  echo "口令过期警告时间天数为${passage},符合要求" >> /tmp/${ipadd}_out.txt
else
  echo "口令过期警告时间天数为${passage},不符合要求，建议设置大于等于30并小于口令生存周期" >> /tmp/${ipadd}_out.txt
fi

