#!/bin/bash

ZABBIX_SERVER_IP=192.168.1.10

# Adicionando o repositorio do zabbix
cd /tmp
wget -c 'https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb'

sudo dpkg -i ./zabbix-release_5.0-1+focal_all.deb

# Instalando o zabbix-agent
sudo apt update && sudo apt install -y zabbix-agent

# Configurando o IP do servidor zabbix
sudo sed -i "s/Server=127.0.0.1/Server=$ZABBIX_SERVER_IP/g" /etc/zabbix/zabbix_agentd.conf
sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=$ZABBIX_SERVER_IP/g" /etc/zabbix/zabbix_agentd.conf

# Reiniciando o zabbix-agent
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-agent
