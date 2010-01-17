node default {

  if $operatingsystem == "Solaris" {
    Package { provider => pkg, } 
  }

  # java apps (sun SDK)
  if ($operatingsystem == "Fedora" or $operatingsystem == "CentOS" ) {
    exec {
      "epel":
        command => "/bin/rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/i386/epel-release-5-3.noarch.rpm",
        unless  => "/bin/rpm -qa | /bin/grep epel-release-5-3",
    }
  }

  exec {
    "lenny_key_missing_for_some_reason":
      onlyif => "/usr/bin/test -f /usr/bin/apt-key",
      command => "/usr/bin/apt-key adv --keyserver wwwkeys.eu.pgp.net --recv-keys 9AA38DCD55BE302B && /usr/bin/apt-get update",
  }


   $java_packages = $operatingsystem ? {
        Fedora  => "java-1.6.0-openjdk",
        CentOS  => "java-1.6.0-openjdk",
        Ubuntu  => "openjdk-6-jre-headless",
        Debian  => "openjdk-6-jre-headless",
        Solaris => "SUNWj6rt",
        Gentoo  => "virtual/jdk",
        default => undef,  
   }

  package {
    $java_packages:
      ensure => installed,
      require => Exec["lenny_key_missing_for_some_reason"],
  }

  include default_packages
  include rubygems
  include git
  include users

}

class default_packages {

 $default_packages = $operatingsystem ? { 
    Solaris => [ "SUNWgcc", "SUNWgmake", "SUNWgnu-automake-110", "SUNWrrdtool", "SUNWmysql5",   "SUNWpostgr-83-server" ],
    Gentoo  => [ "sys-devel/gcc", "sys-devel/make", "sys-devel/automake", "net-analyzer/rrdtool", "dev-db/mysql", "dev-db/postgresql" ],  
    default => [ "gcc",     "make",      "automake",             "rrdtool",     "mysql-server", "postgresql" ],
  }


  package {
    $default_packages:
      ensure => present,
      require => Exec["lenny_key_missing_for_some_reason"],
  }
}

class rubygems {

  package {
    "ruby_dev":
      name => $operatingsystem ? {
         Fedora  => [ "ruby-devel", "postgresql-devel",   "mysql-devel",        "sqlite",  "sqlite-devel",   "rrdtool-devel", "openldap-devel" ],
         CentOS  => [ "ruby-devel", "postgresql-devel",   "mysql-devel",        "sqlite",  "sqlite-devel",   "rrdtool-devel", "openldap-devel" ],
         Ubuntu  => $operatingsystemrelease ? {
             "8.04" => [ "ruby1.8-dev",   "libpq-dev",          "libmysqlclient15-dev", "sqlite3", "libsqlite3-dev",    "libldap2-dev" ],
             default => [ "ruby-dev",   "libpq-dev",          "libmysqlclient-dev", "sqlite3", "libsqlite3-dev", "librrd-dev",    "libldap2-dev" ],
         },
         Debian  => [ "ruby-dev",   "libpq-dev",          "libmysqlclient-dev", "sqlite3", "libsqlite3-dev", "librrd-dev",    "libldap2-dev" ],
         Gentoo => [ "dev-ruby/ruby-ldap", "net-analyzer/rrdtool", "dev-ruby/ruby-rrd" ],
         Solaris => [ "ruby-dev", "SUNWlldap", ],
         default => undef,
      },
      ensure => present,
      require => Class["default_packages"],
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
      options   => "--no-ri --no-rdoc",
      require  => Package["ruby_dev"],
  }
}

class users {

  if $operatingsystem == "Solaris" {
      $hudsonhome = "/hudson"
      $puppethome = "/puppet"
  } else {
      $hudsonhome = "/home/hudson"
      $puppethome = "/home/puppet"
  }

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
    "$hudsonhome/.puppet":
      owner   => "hudson",
      group   => "puppet",
      ensure  => directory,
      require => File["$hudsonhome"],
  }

  file {
    "$hudsonhome":
      owner   => "hudson",
      group   => "hudson",
      ensure  => directory,
      require => [ User["hudson"], Group["hudson"] ],
  }

  file {
    "$puppethome":
      owner   => "hudson",
      group   => "puppet",
      ensure  => directory,
      require => [ User["puppet"], Group["puppet"] ],
  }

}

class git {

  $git_package = $operatingsystem ? {
       Fedora  => [ "git" ],
       CentOS  => [ "git" ],
       Ubuntu  => [ "git-core" ],
       Debian  => [ "git-core" ],
       Solaris => [ "SUNWgit" ],
       Gentoo  => [ "dev-util/git" ],
  }

  package {
    "git":
      name   => $git_package,
      ensure => installed,
      require => Exec["lenny_key_missing_for_some_reason"],
  }

  exec {
    "setup_git":
      command => "/usr/bin/git config --global user.email 'hudson@reductivelabs.com'; /usr/bin/git config --global user.name 'Hudson User'",
      require => Package["git"],
  }
}

