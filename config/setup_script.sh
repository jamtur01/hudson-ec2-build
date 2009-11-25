#!/usr/bin/env bash

# Use sudo if it is installed
SUDO=""
if [ -f /usr/bin/sudo ]
    SUDO=/usr/bin/sudo
fi

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

# FIXME - Need some OS dependant stuff here
export DEBIAN_FRONTEND=noninteractive
$SUDO apt-get update
$SUDO apt-get install -y ruby libopenssl-ruby rdoc


# Download the latest rubygems
wget http://rubyforge.org/frs/download.php/60718/rubygems-1.3.5.tgz
tar xf rubygems-1.3.5.tgz
cd rubygems-1.3.5
ruby setup.rb
gem -v
cd /tmp


# Patch Puppet
cd /mnt/puppet
ARCHIVE=`awk '/^__PUPPET_PATCH__/ {print NR + 1; exit 0; }' $0`
tail -n+$ARCHIVE $0 | patch -p1


# Get ready to run puppet
export PATH=/mnt/puppet/bin:/mnt/puppet/sbin:/mnt/facter/bin:$PATH
export RUBYLIB=/mnt/facter/lib:/mnt/puppet/lib


$SUDO puppet /mnt/hudson-ec2-build/config/manifest.pp

cd /home/hudson
java -jar slave.jar -jnlpUrl http://beaker.inodes.org:8080/computer/ec2/slave-agent.jnlp
java -jar 

exit







# The patch below allows us to pass extra options to the gem command


__PUPPET_PATCH__
diff -ur puppet-0.25.0/lib/puppet/provider/package/gem.rb puppet.net/lib/puppet/provider/package/gem.rb
--- puppet-0.25.0/lib/puppet/provider/package/gem.rb    2009-09-04 22:54:19.000000000 +0000
+++ puppet.net/lib/puppet/provider/package/gem.rb   2009-11-24 12:52:44.000000000 +0000
@@ -75,6 +75,10 @@
         # Always include dependencies
         command << "--include-dependencies"
 
+        if options = resource[:options]
+              command += options.split(/\s+/)
+        end
+
         if source = resource[:source]
             begin
                 uri = URI.parse(source)
@@ -99,6 +103,11 @@
             command << resource[:name]
         end
 
+        if build = resource[:build]
+           command << "--"
+              command += build.split(/\s+/)
+        end
+
         output = execute(command)
         # Apparently some stupid gem versions don't exit non-0 on failure
         if output.include?("ERROR")
diff -ur puppet-0.25.0/lib/puppet/type/package.rb puppet.net/lib/puppet/type/package.rb
--- puppet-0.25.0/lib/puppet/type/package.rb    2009-09-04 22:54:19.000000000 +0000
+++ puppet.net/lib/puppet/type/package.rb   2009-11-24 12:56:53.000000000 +0000
@@ -207,6 +207,12 @@
             isnamevar
         end
 
+        newparam(:options) do
+            desc "Options for the gem command"
+        end
+        newparam(:build) do
+            desc "Build options for the gem"
+        end
         newparam(:source) do
             desc "Where to find the actual package.  This must be a local file
                 (or on a network file system) or a URL that your specific

