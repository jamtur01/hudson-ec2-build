# Class: developerbootstrap::solaris
#
# This class installs and configures Solaris hosts to develop and test Puppet 
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class developerbootstrap::solaris {

  include developerbootstrap::params

  if $operatingsystem == "Solaris" {
    Package { provider => pkg, } 
  }

}
