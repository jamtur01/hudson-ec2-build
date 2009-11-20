#!/usr/bin/env bash

# Become root if necessary
sudo -s

# Work in /mnt
cd /mnt

# Download the latest stable puppet
wget http://reductivelabs.com/downloads/puppet/puppet-latest.tgz
tar xf puppet-latest.tgz
cd puppet*

