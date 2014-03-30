PUPPET_CONF_DIR = '/root/.puppet'

Vagrant.configure('2') do |v|
  v.vm.hostname = 'puppet.vagrant'

  # http://nrel.github.io/vagrant-boxes/
  v.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140311.box"
  v.vm.box = "centos6.5_x86_64"
  v.vm.network :private_network, :ip => '192.168.50.4'
  v.vm.synced_folder '.', PUPPET_CONF_DIR, :nfs => true
  v.vm.synced_folder '.', '/vagrant', :disabled => true

  v.vm.provider :virtualbox do |vb|
    vb.name = "puppet.vagrant"
    vb.memory = 615
    vb.cpus = 1
  end

  v.vm.provision :shell, :inline => "puppet apply -v --config #{PUPPET_CONF_DIR}/puppet.conf #{PUPPET_CONF_DIR}/manifests/site.pp"
end
