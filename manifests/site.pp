node 'puppet.local.lan' {
  class { 'puppet::server':
    servertype => 'standalone',
    manifest   => '/etc/puppet/manifests/site.pp',
    modulepath => ['$confdir/modules', '$confdir/dist'],
    ca         => true,
  }
  file { '/etc/puppet/hiera.yaml':
    ensure  => 'present',
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0640',
    source  => 'puppet:///modules/site/puppet/hiera.yaml',
    require => Package['puppetmaster'],
    notify  => Service['puppetmaster'],
  } ->
  file { '/etc/hiera.yaml':
    ensure => 'link',
    target => '/etc/puppet/hiera.yaml',
  }
}

node default {
  hiera_include ('classes', [])

  $packages = hiera_hash('packages', {})
  create_resources('package', $packages)

  $services = hiera_hash('services', {})
  create_resources('service', $services)
}

# vim: set et sw=2 ts=2:
