#!/bin/bash

ZABBIX_MYSQL_PASSWORD=zabbix

cd /tmp

wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
dpkg -i zabbix-release_5.0-1+focal_all.deb
apt update

apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

mysql -u root -e "create database zabbix character set utf8 collate utf8_bin; create user 'zabbix'@'%' identified by '$ZABBIX_MYSQL_PASSWORD'; grant all privileges on zabbix.* to 'zabbix'@'%'; flush privileges; quit;"

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p$ZABBIX_MYSQL_PASSWORD zabbix

sed -i "s/DBPassword=/DBPassword=$ZABBIX_MYSQL_PASSWORD/g" /etc/zabbix/zabbix_server.conf
sed -i 's/# php_value date.timezone Europe/Riga/php_value date.timezone America/Recife/g' /etc/zabbix/apache.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2