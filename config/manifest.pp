node default {

  # java apps (sun SDK)
  if ($operatingsystem == "Fedora") {
    exec {
      "epel":
        command => "/bin/rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm",
        unless  => "/bin/rpm -qa | /bin/grep epel-release-5-3",
    }
  }


   $default_packages = $operatingsystem ? {
        Fedora =>           [ "java-1.7.0-icedtea" ],
        /Ubuntu|Debian/  => [ "openjdk-6-jre-headless" ],
   }

  package {
    $default_packages:
      ensure => installed,
  }

  package {
    [
      # Build Essentials
      "gcc",
      "make",
      "automake",

      # For reports
      "rrdtool",

      "mysql-server",
      "postgresql",
    ]:
      ensure => present,
  }

  include ruby
  include rubygems
  include git
  include users

  include hudson


}

class ruby {

   $ruby_packages = $operatingsystem ? {
        Fedora =>           [ "ruby-devel" ],
        /Ubuntu|Debian/  => [ "ruby-dev" ],
   }

  package {
    $ruby_packages:
      ensure => present,
      before => Package["rake"]
  }

}


class rubygems {

  # We need a specific version of rspec
  package {
    "rspec":
      provider => "gem",
      ensure   => "1.2.2",
      require  => [
        Package["rake"],
      ],
      options  => "--no-ri --no-rdoc",
  }

  # Github gems TODO use gemcutter
  package {
    "relevance-rcov":
      provider => "gem",
      source   => "http://gems.github.com",
      require  => [
        Package["rake"],
      ],
      options  => "--no-ri --no-rdoc",
  }

  package {
    "ruby_dev":
      name => $operatingsystem ? {
         Fedora =>           [ "postgresql-devel", "mysql-devel",        "sqlite",  "sqlite-devel",   "rrdtool-devel", "openldap-devel" ],
         /Ubuntu|Debian/  => [ "libpq-dev",        "libmysqlclient-dev", "sqlite3", "libsqlite3-dev", "librrd-dev",    "libldap-dev" ],
      },
      ensure => present,
#      require => Package["ruby_dev2"],
  }

#  package {
#    "ruby_dev2":
#      name => $operatingsystem ? {
#         Fedora =>           [ "libpng-devel", "freetype-devel",   "libart_lgpl-devel" ],
#         /Ubuntu|Debian/  => [ "libpng-dev",   "libfreetype6-dev", "libart-2.0-dev" ],
#      },
#      ensure => present,
#  }


  package {
    [
      "mysql",
      "postgres",
      "sqlite3-ruby",
      #"RubyRRDtool",
      "ruby-ldap",
    ]:
      provider => "gem",
      require  => [
        Package["ruby_dev"],
        Package["rake"],
      ],
      options   => "--no-ri --no-rdoc",
  }

  package {
    [
      "rake",
      "ci_reporter",
      "mocha",
      "hoe",
      "rails",
      "cucumber",
      "json",
      "stomp",
      "mongrel",
      "daemons",
      "test-unit",
    ]:
      provider => "gem",
      ensure   => present,
      options   => "--no-ri --no-rdoc",
  }
}

class users {

  user {
    [
      "hudson",
      "puppet",
    ]:
      groups => "mail",
  }

  file {
    "/home/hudson/.puppet":
      owner   => "hudson",
      group   => "hudson",
      ensure  => directory,
      require => File["/home/hudson"],
  }

  file {
    "/home/hudson":
      owner   => "hudson",
      group   => "hudson",
      ensure  => directory,
      require => User["hudson"],
  }

  file {
    "/home/puppet":
      owner   => "hudson",
      group   => "puppet",
      ensure  => directory,
      require => User["puppet"],
  }


}

class git {

  $git_package = $operatingsystem ? {
       Fedora =>           [ "git" ],
       /Ubuntu|Debian/  => [ "git-core" ],
  }

  package {
    "git":
      name   => $git_package,
      ensure => installed,
  }

  exec {
    "setup_git":
      command => "/usr/bin/git config --global user.email 'hudson@reductivelabs.com'; /usr/bin/git config --global user.name 'Hudson User'",
      require => Package["git"],
  }
}


class hudson {

    exec {
      "get_hudson":
        command => "/usr/bin/wget -O /home/hudson/slave.jar http://beaker.inodes.org:8080/jnlpJars/slave.jar",
        require => File["/home/hudson"],
    }


}
