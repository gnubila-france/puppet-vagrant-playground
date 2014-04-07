task :default => 'r10k'

desc "Install puppet modules using r10k"
task :r10k do
  sh "r10k -v INFO puppetfile install"
end

desc "Install vagrant plugins"
task :vagrant_plugins do
  sh "vagrant plugin install vagrant-cachier"
  sh "vagrant plugin install vagrant-hostsupdater"
  sh "vagrant plugin install vagrant-vbguest"
end
