# Class: developerbootstrap::hudson
#
# This class installs and configures Hudson client hosts to develop and test Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class developerbootstrap::hudson {

  include developerbootstrap::params

  user {
    [
      "hudson",
      "puppet",
    ]:
      groups => "mail",
  }

  group {
    [
      "hudson",
      "puppet",
    ]:
      require => User["hudson", "puppet"],
  }

  file {
    "$developerbootstrap::params::hudsonhome/.puppet":
      owner   => "hudson",
      group   => "puppet",
      ensure  => directory,
      require => File["$developerbootstrap::params::hudsonhome"],
  }

  file {
    "$developerbootstrap::params::hudsonhome":
      owner   => "hudson",
      group   => "hudson",
      ensure  => directory,
      require => [ User["hudson"], Group["hudson"] ],
  }

  file {
    "$developerbootstrap::params::puppethome":
      owner   => "hudson",
      group   => "puppet",
      ensure  => directory,
      require => [ User["puppet"], Group["puppet"] ],
  }

  exec {
    "setup_git":
      command => "/usr/bin/git config --global user.email 'hudson@reductivelabs.com'; /usr/bin/git config --global user.name 'Hudson User'",
      require => Package[$developerbootstrap::params::git_package],
  }

  package {
    $developerbootstrap::params::java_packages:
      ensure => installed,
  }

}
