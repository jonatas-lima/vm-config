#!/bin/bash

# esse script ainda não funciona!
MYSQL_ROOT_PASSWORD=root
ZABBIX_MYSQL_PASSWORD=zabbix

cd /tmp

wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
dpkg -i zabbix-release_5.0-1+focal_all.deb
apt update

apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent

curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh

docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=zabbix \
  -e MYSQL_USER=zabbix \
  -e MYSQL_PASSWORD=$ZABBIX_MYSQL_PASSWORD \
  --network host \
  mysql:5.7

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | docker exec mysql mysql -uzabbix -p$ZABBIX_MYSQL_PASSWORD zabbix

sed -i "s/DBPassword=/DBPassword=$ZABBIX_MYSQL_PASSWORD/g" /etc/zabbix/zabbix_server.conf
sed -i 's/# php_value date.timezone Europe/Riga/php_value date.timezone America/Recife/g' /etc/zabbix/apache.conf

systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2