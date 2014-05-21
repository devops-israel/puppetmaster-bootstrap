PUPPET_COMPANY_NAME = ENV.fetch('PUPPET_COMPANY_NAME', 'company')

PUPPET_CONF_DIR = '/root/.puppet'
PUPPET_CONF_FILE = '/tmp/.puppet.conf'

Vagrant.configure('2') do |v|
  v.vm.hostname = 'puppet.vagrant'

  # http://nrel.github.io/vagrant-boxes/
  v.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140504.box"
  v.vm.box = "centos6.5_x86_64"
  v.vm.network :private_network, :ip => '192.168.50.4'
  v.vm.synced_folder '.', PUPPET_CONF_DIR, :nfs => true
  v.vm.synced_folder 'puppet', '/opt/company/puppet', :nfs => true
  v.vm.synced_folder '.', '/vagrant', :disabled => true

  v.vm.provider :virtualbox do |vb|
    vb.name = "puppet.vagrant"
    vb.memory = 615
    vb.cpus = 1
  end

  # WARN: do not remove the start-of-line TAB characters in heredocs
  v.vm.provision :shell, :inline => <<-EOF
	cat <<-XXX > #{PUPPET_CONF_FILE}
		[main]
			ssldir = /tmp/.puppet-ssl
			confdir = #{PUPPET_CONF_DIR}
			hiera_config = \\$confdir/hiera.yaml
			basemodulepath = \\$confdir/site-modules:\\$confdir/modules:/usr/share/puppet/modules
	XXX
	cat <<-XXX > #{PUPPET_CONF_DIR}/hiera/global.yaml
	puppet::local_puppet_path: /opt/#{PUPPET_COMPANY_NAME}/puppet
	XXX
	touch #{PUPPET_CONF_DIR}/hiera.yaml
	puppet apply --config #{PUPPET_CONF_FILE} #{PUPPET_CONF_DIR}/manifests/site.pp
  EOF
end
