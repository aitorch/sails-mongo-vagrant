class apt_update {
    exec { "aptGetUpdate":
        command => "sudo apt-get update",
        path => ["/bin", "/sbin/", "/usr/bin", "/usr/sbin", "/bin/sh", "/usr/bin/local"]
    }
}

class basics {
    package { "git":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "vim-common":
        ensure => latest,
        require => Exec["aptGetUpdate"]
    }

    package { "curl":
        ensure => present,
        require => Exec["aptGetUpdate"]
    }
}

class { 'nodejs':
    version => 'v0.10.17',
}

class mongodb {
  exec { "10genKeys":
    command => "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10",
    path => ["/bin", "/usr/bin"],
    notify => Exec["aptGetUpdate"],
    unless => "apt-key list | grep 10gen"
  }

  file { "10gen.list":
    path => "/etc/apt/sources.list.d/10gen.list",
    ensure => file,
    content => "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen",
    notify => Exec["10genKeys"]
  }

  package { "mongodb-10gen":
    ensure => present,
    require => [Exec["aptGetUpdate"],File["10gen.list"]]
  }
}

class grunt{
    package { "grunt-cli",
        provider => npm
    }
}

class sailsjs {
    package { "sails":
        ensure => present,
        provider => npm
    }
    package { "sails-mongo":
        ensure => present,
        provider => npm
    }
}

include apt_update
include basics
include nodejs
include mongodb
include grunt
include sailsjs
