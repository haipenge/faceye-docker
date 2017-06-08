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
                  MASTER_HOST='10.12.12.189', \
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
      
