#!/usr/bin/env bash

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
fi

# Download the latest rubygems
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

puppet /mnt/hudson-ec2-build/config/manifest.pp




