#!/usr/bin/env bash

set -euxo pipefail

sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y

sudo update-alternatives --set iptables /usr/sbin/iptables-legacy

sudo ansible-galaxy collection install -r /vagrant/ansible/requirements.yml
sudo ansible --version