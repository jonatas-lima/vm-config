#!/bin/bash

# esse script ainda não funciona!
MYSQL_ROOT_PASSWORD=root
ZABBIX_MYSQL_PASSWORD=zabbix

cd /tmp

wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
dpkg -i zabbix-release_5.0-1+focal_all.deb
apt update

apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

bash './mysql_secure_installation.sh' $MYSQL_ROOT_PASSWORD

mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE DATABASE zabbix CHARACTER SET utf8 COLLATE utf8_bin"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "CREATE USER 'zabbix'@'%' IDENTIFIED BY '$ZABBIX_MYSQL_PASSWORD'"
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON zabbix.* to 'zabbix'@'%'"

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p$ZABBIX_MYSQL_PASSWORD zabbix

sed -i "s/DBPassword=/DBPassword=$ZABBIX_MYSQL_PASSWORD/g" /etc/zabbix/zabbix_server.conf
sed -i 's/# php_value date.timezone Europe/Riga/php_value date.timezone America/Recife/g' /etc/zabbix/apache.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2