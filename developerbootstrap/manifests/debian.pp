# Class: developerbootstrap::debian
#
# This class installs and configures Debian and Ubuntu hosts to develop and test Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class developerbootstrap::debian {

  include developerbootstrap::params

  exec {
    "lenny_key_missing_for_some_reason":
      onlyif => "/usr/bin/test -f /usr/bin/apt-key",
      command => "/usr/bin/apt-key adv --keyserver wwwkeys.eu.pgp.net --recv-keys 9AA38DCD55BE302B && /usr/bin/apt-get update",
  }

}
