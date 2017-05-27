#Script for docker install on centos
#author:haipenge
#Date:2017.05.27
#删除老版本docker
sudo yum remove docker \
                  docker-common \
                  container-selinux \
                  docker-selinux \
                  docker-engine
#基础环境要求
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
#sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --disable docker-ce-edge
sudo yum makecache fast
sudo yum install docker-ce
sudo systemctl start docker
