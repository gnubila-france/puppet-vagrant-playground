puppet-vagrant-playground
=========================

Testing puppet stuff using Vagrant VMs.

Two Debian Wheezy VirtualBox VMs can be created: master and client.

Master is a basic puppetmaster running with webrick.
Client is a puppet agent configured using hiera and a default node
definition (ie. a nodeless setup).

The puppet modules are installed locally using r10k.

The manifests, modules and hieradata repositories are synchronized with
the puppetmaster in /etc/puppet.

## Prerequisities

* vagrant
* bundler

### Installing required gems

``` shell
bundle install
```

### Installing vagrant plugins

``` shell
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-vbguest
```

## Downloading modules using r10k

``` shell
r10k -v INFO puppetfile install
```

## Bootstraping the puppetmaster

``` shell
vagrant up master
vagrant ssh master
```

## Bootstraping the client

``` shell
vagrant up client
vagrant ssh client
```
