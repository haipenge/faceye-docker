#############################
#Name:Nginx install sh
#Author:haipenge
#Date:2016.01.14
#############################
#bin=`which "$0"`
#bin=`dirname "${bin}"`
#bin=`cd "$bin"; pwd`
#ROOT=$(dirname $(cd "$(dirname "$0")";pwd))
ROOT=$(cd $(dirname '$0');pwd)
NGINX_HOME='/usr/local/nginx'
DOWNLOAD_HOME='/tmp'
cd $ROOT
#Prepare Dir
mkdir -p nginx openssl pcre zlib
#Version Config
PCRE_VERSION=8.40
ZLIB_VERSION=1.2.11
OPEN_SSL_VERSION=1.0.2l
NGINX_VERSION=1.13.0
#####Prepare######################
yum -y update
yum -y install gcc automake autoconf libtool make
yum -y install gcc gcc-c++
yum -y install wget
yum -y install pcre pcre-devel zlib zlib-devel openssl openssl-devel
###################################
if [ ! -d "$NGINX_HOME"]; then
　　mkdir "$NGINX_HOME"  
fi
#Install nginx
#cd $ROOT/nginx
cd $DOWNLOAD_HOME
wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz .
tar -zxvf nginx-$NGINX_VERSION.tar.gz
cd nginx-$NGINX_VERSION
./configure --with-ipv6 --with-http_ssl_module \
--sbin-path=$NGINX_HOME \
--prefix=$NGINX_HOME \
--conf-path=$NGINX_HOME/conf/nginx.conf \
--pid-path=$NGINX_HOME/nginx.pid \

#--with-http_ssl_module \
#--with-pcre=$ROOT/pcre/pcre-$PCRE_VERSION \
#--with-zlib=$ROOT/zlib/zlib-$ZLIB_VERSION \
#--with-openssl=$ROOT/openssl/openssl-$OPEN_SSL_VERSION
#--with-openssl=/app/build/faceye-docker/docker-centos-nginx/openssl/openssl-1.0.2l
make
make install
#Start Nginx default port:80
$NGINX_HOME/nginx
echo '<<<<<<<<<<<<<<<<<<<<<<<Nginx Install Success>>>>>>>>>>>>>>>>>>>>>>>>>'
exit 0


