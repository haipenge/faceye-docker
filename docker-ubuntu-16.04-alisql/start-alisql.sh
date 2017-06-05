#!/bin/bash
###########Docker for alisql####################
#Write by haipenge
#Date 2017.06.05
################################################
echo '...正在从docker.id/haipenge/ubuntu-16.04-alisql 获取镜像文件...'
echo '...如为第一次启动,整体耗时约15分钟,请耐心等候...'
docker pull docker.id/haipenge/ubuntu-16.04-alisql:latest
echo '...已获取最新alisql镜像....'
echo '...默认启动middle 级别的alisql主库...'
echo '...详细配置参考:https://github.com/alibaba/AliSQL/wiki/AliSQL-middle.cnf'
docker run -itd -v /opt:/app -p 13306:3306 ubuntu-16.04-alisql /bin/bash
echo '...系统会自动调用镜像中/opt/tools/alisql/init-middle.sh进行数据库启动与初始化工作...'
echo '...祝使用愉快^_^,解决问题收费^_^,微信:haipenge'