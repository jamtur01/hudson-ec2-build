#!/usr/bin/env bash

# Fix path for solaris
export PATH=/usr/gnu/bin/:$PATH

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
wget -O puppet.tgz http://reductivelabs.com/downloads/puppet/puppet-latest.tgz
tar zxf puppet.tgz
rm puppet.tgz
mv puppet* puppet

# Download the latest stable facter
rm -rf facter*
wget -O facter.tgz http://reductivelabs.com/downloads/facter/facter-latest.tgz
tar zxf facter.tgz
rm facter.tgz
mv facter* facter

# Download the latest rubygems
rm -rf rubygems*
wget -O rubygems.tgz http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz
tar zxf rubygems.tgz
cd rubygems*
ruby setup.rb
ln -s /usr/bin/gem1.8 /usr/bin/gem || true
cd

# Patch Puppet
cd puppet
patch -p1 < $HOME/hudson-ec2-build/puppet_gem_options.patch

# Get ready to run puppet
export PATH=$HOME/puppet/bin:$HOME/puppet/sbin:$HOME/facter/bin:$PATH
export RUBYLIB=$HOME/facter/lib:$HOME/puppet/lib

puppet --color false $HOME/hudson-ec2-build/manifest.pp




