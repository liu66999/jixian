#!/bin/bash


ipadd=`ifconfig -a | grep Bcast | awk -F "[ :]+" '{print $4}'`
echo "
****			       linux基线检查脚本	  	     		*****
*************************************************************************************
*****			       linux基线配置规范				    *****
*****				                  					    *****
*************************************************************************************" >> /tmp/${ipadd}_out.txt
echo "账号策略检查" >> /tmp/${ipadd}_out.txt
echo "*************************************************************************************
" >> /tmp/${ipadd}_out.txt
echo "目标文件：
/etc/login.defs

合规要求：
PASS_MAX_DAYS 小于90 
PASS_WARN_AGE 小于7
PASS_MIN_LEN 大于8
PASS_MIN_DAYS 大于6
" >>/tmp/${ipadd}_out.txt
echo "检查结果：" >> /tmp/${ipadd}_out.txt
passmax=`cat /etc/login.defs | grep PASS_MAX_DAYS | grep -v ^# | awk '{print $2}'`
passage=`cat /etc/login.defs | grep PASS_WARN_AGE | grep -v ^# | awk '{print $2}'`
passlen=`cat /etc/login.defs | grep PASS_MIN_LEN | grep -v ^# | awk '{print $2}'`
passmin=`cat /etc/login.defs | grep PASS_MIN_DAYS | grep -v ^# | awk '{print $2}'`

if [ $passmax ];then
    if [ $passmax -le 90 -a $passmax -gt 0 ];then
        echo "口令生存周期(PASS_MAX_DAYS)为${passmax}天，符合要求" >> /tmp/${ipadd}_out.txt
    else
        echo "口令生存周期(PASS_MAX_DAYS)为${passmax}天，不符合要求,建议设置不大于90天" >> /tmp/${ipadd}_out.txt
    fi
else
    echo "口令生存周期(PASS_MAX_DAYS)未配置，不符合要求" >> /tmp/${ipadd}_out.txt
fi

if [ $passmin ];then
    if [ $passmin -ge 6 ];then
        echo "口令更改最小时间间隔(PASS_MIN_DAYS)为${passmin}天，符合要求" >> /tmp/${ipadd}_out.txt
    else
        echo "口令更改最小时间间隔(PASS_MIN_DAYS)为${passmin}天，不符合要求，建议设置大于等于6天" >> /tmp/${ipadd}_out.txt
    fi
else
    echo "口令更改最小时间间隔(PASS_MIN_DAYS)未配置，不符合要求，建议设置大于等于6天" >> /tmp/${ipadd}_out.txt
fi

if [ $passlen ];then
    if [ $passlen -ge 8 ];then
        echo "口令最小长度(PASS_MIN_LEN)为${passlen},符合要求" >> /tmp/${ipadd}_out.txt
    else
        echo "口令最小长度(PASS_MIN_LEN)为${passlen},不符合要求，建议设置最小长度大于等于8" >> /tmp/${ipadd}_out.txt
    fi
else
    echo "口令最小长度(PASS_MIN_LEN)未配置，不符合要求，建议设置最小长度大于等于8" >> /tmp/${ipadd}_out.txt
fi

if [ $passage ];then
    if [ $passage -ge 6 ] && [ $passage -lt $passmax ];then
        echo "口令过期警告时间天数(PASS_WARN_AGE)为${passage},符合要求" >> /tmp/${ipadd}_out.txt
    else
        echo "口令过期警告时间天数(PASS_WARN_AGE)为${passage},不符合要求，建议设置大于等于666666并小于口令生存周期" >> /tmp/${ipadd}_out.txt
    fi
else
    echo "口令过期警告时间天数(PASS_WARN_AGE)未配置，不符合要求，建议设置大于等于30并小于口令生存周期" >> /tmp/${ipadd}_out.txt
fi

echo "*********************************************************************************************
 账号是否会主动注销检查
***************************************************************************************************" >> /tmp/${ipadd}_out.txt
echo "目标文件：
/etc/profile

合规要求：
超时时间(TMOUT)不大于300秒
" >>/tmp/${ipadd}_out.txt
echo "检查结果：" >> /tmp/${ipadd}_out.txt
TMOUT=`cat /etc/profile | grep -v "#" | grep TMOUT | awk -F [=] '{print $2}'`
if [ $TMOUT ];then
    if [ $TMOUT -le 600 -a $TMOUT -ge 10 ];then
        echo "账号超时时间为${TMOUT}秒,符合要求" >> /tmp/${ipadd}_out.txt
    else
        echo "账号超时时间为${TMOUT}秒,不符合要求，建议设置不大于300秒" >> /tmp/${ipadd}_out.txt
    fi
else
    echo "账号超时不存在自动注销，不符合要求，建议设置不大于300秒" >> /tmp/${ipadd}_out.txt
fi
