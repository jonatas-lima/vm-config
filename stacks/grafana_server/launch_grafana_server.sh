#!/bin/bash

apt-get install -y apt-transport-https
apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -

echo "deb https://packages.grafana.com/enterprise/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list

apt update
apt install -y grafana-enterprise

systemctl daemon-reload
systemctl enable --now grafana-server