Hudson Build Application for Puppet Testing
===========================================

This tool builds Puppet instances to be used for testing with the Hudson CI engine.

It was developed by John Ferlito (http://github.com/johnf)

Instructions
------------

Add the following to the Init Script section of the EC2 instance that you wish to configure

	rm -rf hudson-ec2-build
	wget -O hudson.tar.gz http://github.com/jamtur01/hudson-ec2-build/tarball/master
	tar xf hudson.tar.gz
	mv *hudson-ec2-build* hudson-ec2-build
	hudson-ec2-build/bootstrap.sh
