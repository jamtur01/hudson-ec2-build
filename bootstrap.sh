#!/usr/bin/env bash

# Change to wokring directory
cd /mnt

# Install Ruby
if [ -f /usr/bin/yum ]
then
    yum install -y ruby rdoc
elif [ -f /usr/bin/apt-get ]
then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y ruby libopenssl-ruby rdoc
elif [ -f /usr/bin/emerge ]
then
    emerge dev-lang/ruby
elif [ -f /usr/bin/pkg ]
then
  pkg install -q SUNWruby18
fi

# Download the latest stable puppet
rm -rf puppet*
wget http://reductivelabs.com/downloads/puppet/puppet-latest.tgz
tar xf puppet-latest.tgz
rm puppet-latest.tgz
mv puppet* puppet

# Download the latest stable facter
rm -rf facter*
wget http://reductivelabs.com/downloads/facter/facter-latest.tgz
tar xf facter-latest.tgz
rm facter-latest.tgz
mv facter* facter


# Download the latest rubygems
rm -rf rubygems*
wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz
tar xf rubygems-1.3.5.tgz
cd rubygems-1.3.5
ruby setup.rb
ln -s /usr/bin/gem1.8 /usr/bin/gem
cd /tmp

# Patch Puppet
cd /mnt/puppet
patch -p1 < /mnt/hudson-ec2-build/puppet_gem_options.patch

# Get ready to run puppet
export PATH=/mnt/puppet/bin:/mnt/puppet/sbin:/mnt/facter/bin:$PATH
export RUBYLIB=/mnt/facter/lib:/mnt/puppet/lib

puppet /mnt/hudson-ec2-build/manifest.pp




