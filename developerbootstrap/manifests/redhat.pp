# Class: developerbootstrap::redhat
#
# This class installs and configures Red Hat and CentOS hosts to develop and test Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class developerbootstrap::redhat {

  include developerbootstrap::params

  exec {
    "epel":
      command => "/bin/rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm",
      unless  => "/bin/rpm -q --quiet epel-release",
  }

  exec {
    "elff":
      command => "/bin/rpm -Uvh http://download.elff.bravenet.com/5/i386/elff-release-5-3.noarch.rpm",
      unless  => "/bin/rpm -q --quiet elff-release",
  }

}
