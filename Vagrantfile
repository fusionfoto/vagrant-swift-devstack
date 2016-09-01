RAM_GB = 6144  # not having good luck getting by with less
HOST_IP = "192.168.8.8"

local_config = {
  "user" => 'ubuntu',
  "source_root" => '/vagrant',
  "host_ip" => HOST_IP,
}

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provider :virtualbox do |vb|
    vb.memory = RAM_GB
  end
  config.vm.network :private_network, ip: HOST_IP
  config.vm.synced_folder "stack/", "/opt/stack"

  config.ssh.forward_agent = true
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "devstack"
    chef.json = local_config
  end
end
