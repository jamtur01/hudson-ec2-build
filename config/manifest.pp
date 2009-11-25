node default {

  package {
    [
      # Java for hudson
      "openjdk-6-jre-headless",

      # Stuff to buil gems
      "ruby-dev",
      "libmysqlclient-dev",
      "libpq-dev",
      "librrd-dev",
      "libsqlite3-dev",

      # For reports
      "rrdtool",

      "mysql-server",
      "sqlite3",
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
      require  => [
        Package["rake"],
        Package["rubygems"],
        Package["ruby-dev"],
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
        Package["rubygems"],
        Package["ruby-dev"],
      ],
      options  => "--no-ri --no-rdoc",
  }

  package {
    "mysql":
      provider => "gem",
      require  => [
        Package["libmysqlclient-dev"],
        Package["rake"],
        Package["rubygems"],
        Package["ruby-dev"],
      ],
      options   => "--no-ri --no-rdoc",
  }

  package {
    "postgres":
      provider => "gem",
      require  => [
        Package["libpq-dev"],
        Package["rake"],
        Package["rubygems"],
        Package["ruby-dev"],
      ],
      options   => "--no-ri --no-rdoc",
  }

  package {
    "sqlite3-ruby":
      provider => "gem",
      require  => [
        Package["libsqlite3-dev"],
        Package["rake"],
        Package["rubygems"],
        Package["ruby-dev"],
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
      "ldap",
      "rrd",
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
