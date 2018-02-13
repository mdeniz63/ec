#!/bin/bash

# add nitro user
useradd nitro
echo nitro7 | passwd nitro --stdin

mkdir /ARSIV
chown nitro:nitro /ARSIV

# extract nitro
cd /
tar -zxvf nitro.tar.gz
rm -f /nitro.tar.gz

cp -f /nitro/script/tomcat.service /usr/lib/systemd/system/
cp -f /nitro/script/nitro.sh /etc/profile.d/
source /etc/profile.d/nitro.sh

# install jdk
cd /nitro/script/rpm/
rpm -ivh epel-release-7-8.noarch.rpm
rpm -ivh jdk-8u131-linux-x64.rpm


# install postgresql
cd /nitro/script/rpm/pg96
rpm -ivh postgresql96-libs-9.6.1-1PGDG.rhel7.x86_64.rpm
rpm -ivh postgresql96-9.6.1-1PGDG.rhel7.x86_64.rpm
rpm -ivh postgresql96-server-9.6.1-1PGDG.rhel7.x86_64.rpm
rpm -ivh postgresql96-contrib-9.6.1-1PGDG.rhel7.x86_64.rpm

rm -f /usr/lib/systemd/system/postgresql-9.6.service
cp -f /nitro/script/postgresql.service /usr/lib/systemd/system/
echo "PGDATA=/nitro/data/" > /etc/sysconfig/pgsql/postgresql
echo "PGLOG=/nitro/data/" >> /etc/sysconfig/pgsql/postgresql

# comment for docker not needed

# Start postgresql
#systemctl start postgresql.service
#systemctl enable postgresql.service

# Crontab for postgresql backup
#cd /nitro/script/
#crontab -u postgres postgres_crontab

# Start tomcat
#systemctl start tomcat.service
#systemctl enable tomcat.service

# Enable network on startup
#chkconfig network on
