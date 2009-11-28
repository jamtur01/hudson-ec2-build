#!/usr/bin/env bash

# Grab the latest build script and manifest
cd /mnt
wget http://github.com/johnf/hudson-ec2-build/tarball/master
tar xf *hudson-ec2-build*
rm *.tar.gz
mv *hudson-ec2-build* hudson-ec2-build

# Run the bootstrap script
cd hudson-ec2-build
./bootstrap.sh
