mysqldump -uroot -p  \
--single-transaction --flush-logs \
--master-data=1 --add-drop-table  \
--create-option --quick \
--extended-insert=false  \
--set-charset \
--disable-keys -A > /tmp/alldb.sql


CHANGE MASTER TO \
       MASTER_HOST='10.12.12.189', \
       MASTER_USER='rep1', # 在103 上面改成repl103 \
       MASTER_PASSWORD='rep1', \
       MASTER_PORT=13306,
       MASTER_LOG_FILE='mysql-bin.000001', \
       MASTER_LOG_POS=0, \
       MASTER_CONNECT_RETRY=60;


drop table if exists innodb_index_stats;
drop table if exists innodb_table_stats;
drop table if exists slave_master_info;
drop table if exists slave_relay_log_info;
drop table if exists slave_worker_info;

解决innodb问题:

mysqladmin -u root -p shut down
use mysql
source /opt/alisql/share/mysql_system_tables.sql

