# == Class: puppet
#
# Class used to install a puppet master using PuppetLabs repositories,
# and change values in configuration to use local puppet modules path.
#
# === Parameters
#
# [*local_puppet_path*]
#   Where puppet master should find site-modules and modules folders.
#
# === Examples
#
#  class { puppet:
#    local_puppet_path => '/opt/myorg/puppet',
#  }
#
# === Authors
#
# Evgeny Zislis <evgeny@devops.co.il>
#
# === Copyright
#
# Copyright 2014 Evgeny Zislis <evgeny@devops.co.il>, unless otherwise noted.
#
class puppet(
  $local_puppet_path = '/opt/company/puppet',
  $remote_puppet_git = 'git@githost.com:puppet.git',
) {
  $repo_package_name   = 'puppetlabs-release-6-7'
  $repo_package_url    = 'https://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm'
  $puppet_package_name = 'puppet-server'
  $puppet_service_name = 'puppetmaster'
  $puppet_config_file  = '/etc/puppet/puppet.conf'

  exec { 'yum makecache':
    refreshonly => true,
  }

  package { $repo_package_name:
    provider => 'rpm',
    source   => $repo_package_url,
    notify   => Exec["yum makecache"],
  }

  package { $puppet_package_name:
    require => [ Package[$repo_package_name], Exec['yum makecache'] ],
  }

  file { $puppet_config_file:
    content => template('puppet/puppet.conf.erb'),
    require => Package[$puppet_package_name],
  }

  service { $puppet_service_name:
    ensure  => running,
    enable  => true,
    require => [ Package[$puppet_package_name], File[$puppet_config_file] ],
  }

}
