#!/usr/bin/env bash

# Work in /mnt
cd /mnt

# Download the latest stable puppet
wget http://reductivelabs.com/downloads/puppet/puppet-latest.tgz
tar xf puppet-latest.tgz
rm puppet-latest.tgz
mv puppet* puppet

# Download the latest stable facter
wget http://reductivelabs.com/downloads/facter/facter-latest.tgz
tar xf facter-latest.tgz
rm facter-latest.tgz
mv facter* facter

# Grab the puppet config out of git
wget http://github.com/johnf/hudson-ec2-build/tarball/master
tar xf *hudson-ec2-build*
rm *.tar.gz
mv *hudson-ec2-build* hudson-ec2-build


# Get ready to run puppet
export PATH=/mnt/puppet/bin:/mnt/puppet/sbin:/mnt/facter/bin:$PATH
export RUBYLIB=/mnt/facter/lib:/mnt/puppet/lib

# FIXME - Need some OS dependant stuff here
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ruby libopenssl-ruby rdoc rubygems

puppet /mnt/hudson-ec2-build/config/manifest.pp

