# 前提環境：CentOS 7-minimal

# 好きな情報入れてね
IPADDR=192.168.75.189
PREFIX=24
GATEWAY=192.168.75.2
DNS1=8.8.8.8
ETHNAME=ens32
NODENAME=packstack.localdomain
CINDERDISK=/dev/sdb

# こっから処理開始
## Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
cat /proc/sys/net/ipv6/conf/all/disable_ipv6

## change hostname
echo ${NODENAME} > /etc/hostname
echo ${NODENAME} ${IPADDR} >> /etc/hosts

## disable NetworkManager
systemctl status NetworkManager
systemctl stop NetworkManager
systemctl disable NetworkManager

## configure network
sed -i "s/BOOTPROTO=dhcp/BOOTPROTO=none/" /etc/sysconfig/network-scripts/ifcfg-${ETHNAME}
sed -i "$ a IPADDR=${IPADDR}" /etc/sysconfig/network-scripts/ifcfg-${ETHNAME}
sed -i "$ a PREFIX=${PREFIX}" /etc/sysconfig/network-scripts/ifcfg-${ETHNAME}
sed -i "$ a GATEWAY=${GATEWAY}" /etc/sysconfig/network-scripts/ifcfg-${ETHNAME}
sed -i "$ a DNS1=${DNS1}" /etc/sysconfig/network-scripts/ifcfg-${ETHNAME}

## disable SELinux
sed -i "s/\(^SELINUX=\).*/\1disabled/" /etc/selinux/config

## disable firewalld
systemctl stop firewalld
systemctl disable firewalld

## create LVM for cinder
parted -s ${CINDERDISK} 'mklabel gpt'
parted -s ${CINDERDISK} 'mkpart primary 0 -1'
parted -s ${CINDERDISK} 'set 1 lvm on'
parted -s ${CINDERDISK} 'print'
partprobe ${CINDERDISK}
cat /proc/partitions
pvcreate -y -ff /dev/sdb1
vgcreate -y -f cinder-volumes /dev/sdb1

## config environment
echo 'LANG=en_US.utf-8
LC_ALL=en_US.utf-8' > /etc/environment

## install openstack-repo
yum install -y centos-release-openstack-pike

## install openstack
yum install -y openstack-packstack

## update
yum update -y
yum install -y yum-utils
reboot

## deploy openstack
packstack --allinone
