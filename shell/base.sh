#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo 'This script must be run as root.' >&2
  exit 1
fi

if which puppet > /dev/null 2>&1; then
  echo 'Puppet is already installed'
  exit 0
fi

if ! grep -q nameserver /etc/resolv.conf; then
  echo 'No nameserver found...'
  echo 'Adding 8.8.8.8 as nameserver'
  echo 'nameserver 8.8.8.8' > /etc/resolv.conf
fi

# Debian-based systems
if [ -f '/etc/debian_version' ]; then

  # Add puppetlabs repo definitions
  wget http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
  dpkg -i puppetlabs-release-wheezy.deb

  # Update packages list
  aptitude update

  # Upgrade system in two steps
  # - keeping modified files
  # - using updated files for untouched files
  aptitude -V -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    -y upgrade
  aptitude -V -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    -y full-upgrade
  echo 'System successfully updated'

  # Install puppet
  aptitude -y install puppet
  echo 'Puppet successfully installed'
fi

exit 0
