# packages
[
  "git",
  "lvm2",  # lp bug #1619195
].each do |pkg|
  package pkg do
    action :install
  end
end

# dirs
directory "#{node['source_root']}" do
  owner "#{node['user']}"
  group "#{node['user']}"
  action :create
end

# devstack
execute "git python-swiftclient" do
  cwd "#{node['source_root']}"
  user "#{node['user']}"
  command "git clone git://github.com/openstack-dev/devstack.git"
  creates "#{node['source_root']}/devstack"
  action :run
end

execute "unstack" do
  cwd "#{node['source_root']}"
  user "#{node['user']}"
  command "./devstack/unstack.sh"
  action :run
end

template "/#{node['source_root']}/devstack/local.conf" do
  source "/devstack/local.conf.erb"
  owner "#{node['user']}"
  group "#{node['user']}"
  variables({
    :host_ip => node['host_ip'],
  })
end

execute "stack" do
  cwd "#{node['source_root']}"
  user "#{node['user']}"
  group "#{node['user']}"
  command "./devstack/stack.sh"
  environment ({
    'RECLONE' => 'yes',
    'HOME' => "/home/#{node['user']}",
  })
  action :run
end
