#!/bin/bash

wget https://github.com/prometheus/node_exporter/releases/download/v1.10.2/node_exporter-1.10.2.linux-amd64.tar.gz

tar xvfz node_exporter-*.*-amd64.tar.gz
sudo chown root: node_exporter-*.*-amd64/node_exporter
sudo mv node_exporter-*.*-amd64/node_exporter /usr/local/bin/

sudo rm -rf node_exporter-*.*-amd64/node_exporter*

sudo cp node_exporter.service /etc/systemd/system/node_exporter.service
sudo chown root: /etc/systemd/system/node_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable node_exporter.service
sudo systemctl start node_exporter.service
