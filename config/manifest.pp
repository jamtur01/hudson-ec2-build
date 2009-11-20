node default {

  package {
    [
      "ruby",
      "rubygems",
      "rake",
      "git-core",
      "ruby-dev",
      "libldap-ruby1.8",
      "librrd-ruby",
      "librrd-dev",
      "rrdtool",
      "mysql-server",
      "libmysql-ruby",
      "sqlite3",
      "libsqlite3-ruby",
      "libtest-unit-ruby",
      "mongrel",
      "libdaemons-ruby1.8",
    ]:
      ensure => present,
  }

  # We need a specific version of rspec
  package {
    "rspec":
      provider => "gem",
      ensure   => "1.2.2",
      require  => Package["rubygems"],
  }

  # Github gems TODO use gemcutter
  package {
    "relevance-rcov":
      provider => "gem",
      source   => "http://gems.github.com",
      require  => Package["rubygems"],
  }

  package {
    [
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
  }


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

  exec {
    "setup_git":
      command => "/usr/bin/git config --global user.email 'hudson@reductivelabs.com'; /usr/bin/git config --global user.name 'Hudson User'",
      require => Package["git-core"],
  }

}

