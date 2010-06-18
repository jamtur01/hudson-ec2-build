# Class: developerbootstrap
#
# This class installs and configures hosts to develop and test Puppet
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class developerbootstrap {

  include developerbootstrap::params

  case $operatingsystem {
    'fedora','redhat','centos': { require developerbootstrap::redhat }
    'ubuntu','debian': { require developerbootstrap::ubuntu }
    'solaris': { require developerbootstrap::solaris }
  }

  package {
    $developerbootstrap::params::default_packages:
      ensure => present,
  }

  package {
    $developerbootstrap::params::rubydev_packages:
      ensure => present,
      require => Package[$developerbootstrap::params::default_packages],
  }

  package {
    "relevance-rcov":
      provider => "gem",
      require  => Package["rake"],
  }

  package {
    [
      "mysql",
      "postgres",
      "sqlite3-ruby",
      #"RubyRRDtool",
      "ruby-ldap",
      "mongrel",
      "ci_reporter",
      "mocha",
      "hoe",
      "rails",
      "cucumber",
      "json",
      "stomp",
      "daemons",
      "test-unit",
      "rspec", 
      "rake",
      "facter", 
    ]:
      provider => "gem",
      ensure   => present,
      require  => Package[$developerbootstrap::params::rubydev_packages],
  }
  
  package {
    $developerbootstrap::params::git_package:
      ensure => installed,
  }

}
