#!/bin/bash
#For my-middle.cnf
datadir=/app/data/alisql/data3029
if [ ! -x "$datadir/data"]; then
  mkdir $datadir/data
  mkdir $datadir/mysql
  chown -R mysql:mysql $datadir
  cd /opt/alisql
  mv /etc/my.cnf /tmp
  ./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=$datadir/data
  mv /tmp/my.cnf /etc
  service mysqld start
fi

