wget -O /mnt/hudson.tar.gz http://github.com/johnf/hudson-ec2-build/tarball/master
tar xf /mnt/hudson.tar.gz -C /mnt
mv /mnt/*hudson-ec2-build* /mnt/hudson-ec2-build
/mnt/hudson-ec2-build/bootstrap.sh
