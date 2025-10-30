#!/bin/bash

wget https://github.com/prometheus-community/smartctl_exporter/releases/download/v0.14.0/smartctl_exporter-0.14.0.linux-amd64.tar.gz

tar xvfz smartctl_exporter-*-amd64.tar.gz
sudo chown root: smartctl_exporter-*-amd64/smartctl_exporter
sudo mv smartctl_exporter-*-amd64/smartctl_exporter /usr/local/bin/

sudo rm -rf smartctl_exporter-*-amd64*

sudo cp smartctl_exporter.service /etc/systemd/system/smartctl_exporter.service
sudo chown root: /etc/systemd/system/smartctl_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable smartctl_exporter.service
sudo systemctl start smartctl_exporter.service
