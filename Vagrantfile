# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "debian7-64-nocm"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-nocm.box"

  # vagrant-cachier - cache at the box level
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true

  # Shell provisionner for bootstrapping puppet agent
  config.vm.provision "shell", path: "shell/base.sh"

  # Setup the Puppet master
  config.vm.define :master, primary: true do |node|
    # Configure memory
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", 2]
    end
    # Set hostname
    node.vm.hostname = "puppet.local.lan"
    # Set ip address
    node.vm.network "private_network", ip: "192.168.33.10"

    # Update host' /etc/hotsts
    if Vagrant.has_plugin?("vagrant-hostsupdater")
      node.hostsupdater.aliases = ["puppet"]
    end

    node.vm.synced_folder  "manifests", "/etc/puppet/manifests"
    node.vm.synced_folder  "hieradata", "/etc/puppet/hieradata"
    # Share remote modules previously retrieved using r10k
    node.vm.synced_folder  "modules", "/etc/puppet/modules"
    node.vm.synced_folder  "dist", "/etc/puppet/dist"

    # Create a puppetmaster using puppet apply
    node.vm.provision :puppet do |puppet|
      # Path on host to puppet manifests
      puppet.manifests_path = "manifests"
      # Relative path to the default manifest
      puppet.manifest_file  = "site.pp"
      # Path on host to puppet modules
      # Be sure to synchronize remote modules to ./modules dir using
      # r10k
      puppet.module_path = ["dist", "modules"]
    end
  end

  config.vm.define :client do |node|
    # Configure memory
    node.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    # Set hostname
    node.vm.hostname = "client.local.lan"
    # Set ip address
    node.vm.network "private_network", ip: "192.168.33.11"
    # Configure /etc/hosts puppetmaster entry using puppet
    node.vm.provision :shell, :inline => "puppet resource host puppet.local.lan ip='192.168.33.10' host_aliases='puppet'"
    node.vm.provision(:puppet_server) do |puppet|
      puppet.options = "-tv"
   end
  end

end
