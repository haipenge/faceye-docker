#!/bin/bash
#For my-middle.cnf
datadir=/app/data/alisql/data3306
if [ ! -x "$datadir" ]; then
  mkdir -p $datadir $datadir/data  $datadir/mysql
  chown -R mysql:mysql $datadir
  cd /opt/alisql
  mv /etc/my.cnf /tmp
  ./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=$datadir/data 
  # mv /tmp/my.cnf /etc
  # cp /app/data/build/faceye-docker/docker-ubuntu-16.04-alisql/my-middle.cnf /etc/my.cnf
   cp /opt/tools/alisql/conf/my-large.cnf /etc/my.cnf
   service mysqld start
   ln -sf $datadir/tmp/mysql.sock /tmp/mysql.sock
   cd /opt/alisql
   ./bin/mysqladmin -u root password 'root'

else
   service mysqld start
   ln -sf $datadir/tmp/mysql.sock /tmp/mysql.sock
fi