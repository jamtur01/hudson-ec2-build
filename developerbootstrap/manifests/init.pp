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
    'redhat','centos','OEL': { require developerbootstrap::redhat }
    'debian': { require developerbootstrap::debian }
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
      source   => "http://gems.github.com",
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
      "gherkin",
      "cucumber",
      "json",
      "stomp",
      "daemons",
      "test-unit",
      "rspec",
      "rake",
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
