# Class: developerbootstrap::params
#
# This class provides parameters to the developerbootstrap module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class developerbootstrap::params {

  $default_packages = $operatingsystem ? {
    Solaris => [ "SUNWgcc", "SUNWgmake", "SUNWgnu-automake-110", "SUNWrrdtool", "SUNWmysql5",   "SUNWpostgr-83-server" ],
    Gentoo  => [ "sys-devel/gcc", "sys-devel/make", "sys-devel/automake", "net-analyzer/rrdtool", "dev-db/mysql", "dev-db/postgresql" ],
    default => [ "gcc",     "make",      "automake",             "rrdtool",     "mysql-server", "postgresql" ],
  }


  $rubydev_packages = $operatingsystem ? {
         /CentOS|Fedora|RedHat|OEL/  => [ "ruby-devel", "postgresql-devel", "mysql-devel", "sqlite", "sqlite-devel", "rrdtool-devel", "openldap-devel" ],
         Ubuntu  => $operatingsystemrelease ? {
             /'9.04'|'8.04'/ => [ "ruby1.8-dev",   "libpq-dev",          "libmysqlclient15-dev", "sqlite3", "libsqlite3-dev",    "libldap2-dev" ],
             default => [ "ruby-dev",   "libpq-dev",          "libmysqlclient-dev", "sqlite3", "libsqlite3-dev", "librrd-dev",    "libldap2-dev" ],
         },
         Debian  => [ "ruby-dev",   "libpq-dev",          "libmysqlclient-dev", "sqlite3", "libsqlite3-dev", "librrd-dev",    "libldap2-dev" ],
         Gentoo => [ "dev-ruby/ruby-ldap", "net-analyzer/rrdtool", "dev-ruby/ruby-rrd" ],
         Solaris => [ "ruby-dev", "SUNWlldap", ],
         default => undef,
  }

  $git_package = $operatingsystem ? {
       /CentOS|Fedora|RedHat|OEL/ => [ "git", "git-email" ],
       /Debian|Ubuntu/  => [ "git-core", "git-email" ],
       Solaris => [ "SUNWgit" ],
       Gentoo  => [ "dev-util/git" ],
  }

  $hudsonhome = $operatingsystem ? {
       Solaris => '/hudson',
       default => '/home/hudson',
  }

   $puppethome = $operatingsystem ? {
       Solaris => '/puppet',
       default => '/home/puppet',
  }

  $java_packages = $operatingsystem ? {
        /Fedora|Centos|RedHat|OEL/ => "java-1.6.0-openjdk",
        /Ubuntu|Debian/ => "openjdk-6-jre-headless",
        Solaris => "SUNWj6rt",
        Gentoo  => "virtual/jdk",
        default => undef,
   }

}
