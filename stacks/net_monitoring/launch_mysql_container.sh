#!/bin/bash

# Instalando o docker
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh

# Variáveis do banco de dados
MYSQL_ROOT_PASSWORD=root
DB_NAME=net
DB_USER=net_user
DB_PASSWORD=net_password

# Iniciando o container
sudo docker run -d -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
  -e MYSQL_DATABASE=$DB_NAME \
  -e MYSQL_USER=$DB_USER \
  -e MYSQL_PASSWORD=$DB_PASSWORD \
  -v $(pwd)/mysql_conf:'/etc/mysql/mysql.conf.d' \
  -v $(pwd)/mysql_data:'/docker-entrypoint-initdb.d' \
  -v mysql-data:'/var/lib/mysql' \
  --network host \
  --name mysql \
  mysql:5.7
