docker-ubuntu-16.04-alisql
==============
          
      开始之前：
      主从库配置要点：
      1.主库
        1).vi /etc/my.cnf
        2).[mysqld]
           #添加
           server-id = 0
           binlog-do-db = [sync_db_name]
           replicate-do-db = [sync_db_name]
      2.从库
        1).vi /etc/my.cnf
        2).[mysqld]
           #添加
           server-id = 1
        3).
           CHANGE MASTER TO \
                  MASTER_HOST='10.11.100.156', \
                  MASTER_USER='rep01', # 在103 上面改成repl103 \
                  MASTER_PASSWORD='rep01', \
                  MASTER_PORT=13306,
                  MASTER_LOG_FILE='mysql-bin.000001', \
                  MASTER_LOG_POS=0, \
                  MASTER_CONNECT_RETRY=60;
      3.使用
            

      脚本说明：
         1).start-alisql.sh
            使用镜像:docker.id/haipenge/ubuntu-16.04-alisql:latest
            启动单机模式
         2).start-alisql-master.sh
            启动主
         3).start-alisql-slave.sh
            启动从

      注:默认使用alisql my-middle.cnf


      异常问题的解决：
      1.InnoDB: Cannot open table mysql/slave_master_info
        原因：用于主从同步的几个表，本应使用Innodb创建，但使用了MyISM。
        处理：删除，重建
        1).登陆mysql
        2).依次执行：
           drop table if exists innodb_index_stats;
           drop table if exists innodb_table_stats;
           drop table if exists slave_master_info;
           drop table if exists slave_relay_log_info;
           drop table if exists slave_worker_info;
        2).删除/app/data/alisql/data3029/data/mysql下的*.ibd文件
        3).重启mysql服务
        4).登陆mysql
           执行:
           use mysql
           source /opt/alisql/share/mysql_system_tables.sql
        5).重启
      2.centos大内存页问题
        宿主机器分别执行：
        echo never /sys/kernel/mm/transparent_hugepage/defrag
        echo never /sys/kernel/mm/transparent_hugepage/enabled

        注：以上解决在服务器重启后会失效
        长效机制：
        参考资料：https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/

        Create the following file at /etc/init.d/disable-transparent-hugepages:
#!/bin/bash
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    re='^[0-1]+$'
    if [[ $(cat ${thp_path}/khugepaged/defrag) =~ $re ]]
    then
      # RHEL 7
      echo 0  > ${thp_path}/khugepaged/defrag
    else
      # RHEL 6
      echo 'no' > ${thp_path}/khugepaged/defrag
    fi

    unset re
    unset thp_path
    ;;
esac



        常用命令：
        1.启动
          service mysqld start
        2.停止：
          source /etc/profile
          mysqladmin -u root -p shut down
        3.查看主从状态
          show master status;
          show slave status;
        4.主从启动、停止
          mysql>start master;
          mysql>stop master;
          mysql>start slave;
          mysql>stop slave;
        5.其它
          SHOW PROCESSLIST;
          SHOW VARIABLES LIKE 'server_id';
          reset slave;

      与作者联系：[微信 haipenge]

生产环境操作记录：
156:mysql
GRANT REPLICATION SLAVE ON *.* TO 'rep01'@'10.11.100.%' IDENTIFIED BY 'rep01'; 
FLUSH PRIVILEGES;
mysqldump -uroot -pPW57-mysql --databases nuc >/opt/data/bak/nuc_20170609.sql


156：alisql-master
GRANT REPLICATION SLAVE ON *.* TO 'rep01'@'10.11.100.%' IDENTIFIED BY 'rep01'; 
FLUSH PRIVILEGES;

#mysql-proxy用户，需要所有主从库上执行相同的操作
GRANT REPLICATION SLAVE ON *.* TO 'proxy'@'%' IDENTIFIED BY 'proxy'; 
FLUSH PRIVILEGES;

grant all on *.* to 'proxy'@'%' identified by 'proxy';


mysql-proxy
宿主:10.11.100.156
>cd /opt/data/docker/docker-ubuntu-16.04-alisql
启动
>sh start-alisql-proxy.sh
>docker exec -it alisql-proxy /bin/bash
>cd /opt/tools/mysql-proxy
>sh start.sh

停止
killall -9 mysql-proxy

连接数据库
10.11.100.156:43306
用户:proxy
密码:proxy

使用 bin-log恢复数据
1).查看binlog信息
  show binlog events 'mysql-bin.000592'\G
2).使用binlog恢复
  直接恢复
    mysqlbinlog --start-position=148753127 /app/data/bak/mysql-bin-logs/mysql-bin.000592 | mysql -u root -proot nuc
  导出SQL
    mysqlbinlog --start-datetime='2017-01-01 01:00:00' /app/data/bak/mysql-bin-logs/mysql-bin.000592 >/tmp/00592.sql | mysql -u root -proot

mysqlbinlog --skip-gtids /opt/aspire/product/data/mysql/mysql-bin.000594 > /opt/data/bak/sync_156_docker_master_sql_20170614/000594.sql
