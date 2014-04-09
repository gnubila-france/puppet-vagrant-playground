puppet-vagrant-playground
=========================

Testing puppet stuff using Vagrant VMs.

Two Debian Wheezy VirtualBox VMs can be created: master and client.

* Master is a basic puppetmaster running with webrick.
* Client is a puppet agent configured using hiera and a default node
definition (ie. a nodeless setup).

Provisionning is done in two steps:
* A shell script shell/base.sh will update the VM and install puppet
* Provisionning using puppet
  * Puppet apply will be used to provision the puppetmaster
  * Puppet agent will provision the client, using previously configured master

The local puppet modules are stored into the dist directory.
The remote puppet modules are installed locally in the modules directory
on the host using r10k.

The manifests, modules, dist and hieradata directories are synchronized
with the puppetmaster in /etc/puppet.

## Prerequisities

* vagrant
* bundler

### Installing required gems

The gems from the Gemfile will be installed.

A rvm profile configuration is provided.

``` shell
bundle install
```

### Installing vagrant plugins

``` shell
vagrant plugin install vagrant-cachier
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-vbguest
```

A rake task is also provided:

``` shell
rake vagrant_plugins
```

## Downloading modules using r10k

The modules that will be installed to the modules directory are listed
into the Puppetfile.

``` shell
r10k -v INFO puppetfile install
```

A rake task is also provided:

``` shell
rake r10k
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

### Signing the puppet certificate of the client

``` shell
vagrant ssh master
sudo puppet cert sign client.local.lan
```

### Manually launching the puppet agent

``` shell
sudo puppet agent -vt
```

## Knwon bugs

* VirtualBox 4.3.10 additions are broken with regards to vboxsf:
 * https://github.com/mitchellh/vagrant/issues/3341
 * https://www.virtualbox.org/ticket/12879

### Workaround for VirtualBox 4.3.10 Guest Additions

Required at each VM recreation.

* Fix the VBox additions and reload the VM:

``` shell
vagrant ssh master -c 'sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions'
vagrant reload master
```

## Links
* [bundler](http://bundler.io/)
* [Hiera](http://docs.puppetlabs.com/hiera/1/)
* [Puppet](http://docs.puppetlabs.com/puppet/latest/reference/)
* [r10k](https://github.com/adrienthebo/r10k)
* [rake](http://github.com/jimweirich/rake)
* [rvm](http://rvm.io/)
* [Vagrant cachier](https://github.com/fgrehm/vagrant-cachier)
* [Vagrant hostsupdater](://github.com/cogitatio/vagrant-hostsupdater)
* [Vagrant](http://www.vagrantup.com/)
* [Vagrant vbguest](https://github.com/dotless-de/vagrant-vbguest)
