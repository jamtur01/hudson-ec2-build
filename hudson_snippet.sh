rm -rf hudson-ec2-build
wget -O hudson.tar.gz http://github.com/jamtur01/hudson-ec2-build/tarball/master
tar xf hudson.tar.gz
mv *hudson-ec2-build* hudson-ec2-build
hudson-ec2-build/bootstrap.sh
