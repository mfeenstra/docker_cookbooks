include_recipe 'docker-engine::firewall'
include_recipe 'docker-engine::repos'
include_recipe 'docker-engine::packages'
include_recipe 'docker-engine::services'

group 'docker' do
  members [node['docker']['user']]
end

directory "/home/#{node['docker']['user']}/.docker" do
  owner node['docker']['user']
  group node['docker']['user']
  mode '0755'
  recursive true
end

template node['docker']['service_file'] do
  notifies :restart, 'service[docker]', :delayed
  notifies :run, 'execute[reload_systemd]', :immediate
end

template '/etc/profile.d/docker_env.sh'
template '/etc/docker/daemon.json' do
  notifies :restart, 'service[docker]', :delayed
  notifies :run, 'execute[reload_systemd]', :immediate
end

execute 'reload_systemd' do
  command 'systemctl daemon-reload'
  live_stream true
  action :nothing
end

