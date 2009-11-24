node default {

  include ruby
  include rubygems
  include git
  include users

  include hudson

  package {
    [
      "openjdk-6-jre-headless",

      "ruby-dev",
      "libmysqlclient-dev",
      "libpq-dev",
      "librrd-dev",
      "libsqlite3-dev",

      "libldap-ruby1.8",
      "librrd-ruby",
      "rrdtool",
      "mysql-server",
      "sqlite3",
      "libtest-unit-ruby",
      "mongrel",
      "libdaemons-ruby1.8",
    ]:
      ensure => present,
  }
}

class ruby {

  package {
    [ "ruby", "rubygems" ]:
      ensure => present,
  }


}


class rubygems {

  # We need a specific version of rspec
  package {
    "rspec":
      provider => "gem",
      ensure   => "1.2.2",
      require  => Package["rubygems"],
      options  => "--no-ri --no-rdoc",
  }

  # Github gems TODO use gemcutter
  package {
    "relevance-rcov":
      provider => "gem",
      source   => "http://gems.github.com",
      require  => Package["rubygems"],
      options  => "--no-ri --no-rdoc",
  }

  package {
    "mysql":
      provider => "gem",
      require  => [
        Package["rubygems"],
        Package["libmysqlclient-dev"],
      ],
      options   => "--no-ri --no-rdoc",
  }

  package {
    "postgres":
      provider => "gem",
      require  => [
        Package["rubygems"],
        Package["libpq-dev"],
      ],
      options   => "--no-ri --no-rdoc",
  }

  package {
    "sqlite3-ruby":
      provider => "gem",
      require  => [
        Package["rubygems"],
        Package["libsqlite3-dev"],
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
    ]:
      provider => "gem",
      ensure   => present,
      require  => Package["rubygems"],
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

  package {
    "git-core":
      ensure => installed,
  }

  exec {
    "setup_git":
      command => "/usr/bin/git config --global user.email 'hudson@reductivelabs.com'; /usr/bin/git config --global user.name 'Hudson User'",
      require => Package["git-core"],
  }
}


class hudson {

    exec {
      "get_hudson":
        command => "/usr/bin/wget -O /home/hudson/slave.jar http://beaker.inodes.org:8080/jnlpJars/slave.jar",
        require => File["/home/hudson"],
    }


}
