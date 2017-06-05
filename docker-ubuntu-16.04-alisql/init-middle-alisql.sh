#!/bin/bash
#For my-middle.cnf
datadir=/app/data/alisql/data3029
if [ ! -x "$datadir" ]; then
  mkdir -p $datadir $datadir/data $datadir/dbs3029 $datadir/mysql
  chown -R mysql:mysql $datadir
  cd /opt/alisql
  mv /etc/my.cnf /tmp
  ./scripts/mysql_install_db --user=mysql --basedir=/opt/alisql --datadir=$datadir/data
  # mv /tmp/my.cnf /etc
  # cp /app/data/build/faceye-docker/docker-ubuntu-16.04-alisql/my-middle.cnf /etc/my.cnf
   cp /app/build/faceye-docker/docker-ubuntu-16.04-alisql/my-middle.cnf /etc/my.cnf
  # service mysqld start
else
  echo '#service mysqld start'
fi
