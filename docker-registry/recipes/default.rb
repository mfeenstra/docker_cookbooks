include_recipe 'docker-registry::firewall'
include_recipe 'docker-registry::repos'
include_recipe 'docker-registry::packages'
include_recipe 'docker-registry::services'

group 'docker' do
  members [node['user']]
end

directory "/home/#{node['user']}/.docker" do
  owner node['user']
  group node['user']
  mode '0755'
  recursive true
end

directory '/etc/systemd/system/docker.service.d' do
  owner 'root'
  group 'root'
  mode '0750'
  recursive true
end

template '/etc/systemd/system/docker.service.d/http-proxy.conf' do
  notifies :restart, 'service[docker]', :delayed
  notifies :run, 'execute[reload_systemd]', :immediate
end

template '/usr/lib/systemd/system/docker.service' do
  notifies :restart, 'service[docker]', :delayed
  notifies :run, 'execute[reload_systemd]', :immediate
end

template '/etc/docker/daemon.json' do
  notifies :restart, 'service[docker]', :delayed
  notifies :run, 'execute[reload_systemd]', :immediate
end

execute 'reload_systemd' do
  command 'systemctl daemon-reload'
  live_stream true
  action :nothing
end

execute 'pull docker registry image' do
  command node['docker']['pull_registry']
  live_stream true
  not_if { `docker image ls registry`.match?(/^registry\ /) }
end

execute 'pull centos image' do
  command node['docker']['pull_centos']
  live_stream true
  not_if { `docker image ls centos`.match?(/^centos\ +latest\ /) }
end

execute 'tag the community image' do
  command node['docker']['tag_centos']
  live_stream true
  not_if { `docker image ls #{node['docker']['centos_localname']}`.match?(/^#{node['hostname']}\:\d+\/centos/) }
end

execute "push image #{node['docker']['centos_localname']} locally" do
  command "docker push #{node['docker']['centos_localname']}"
  live_stream true
  ignore_failure true
  not_if { `docker image ls #{node['docker']['centos_localname']}`.match?(/^#{node['hostname']}\:\d+\/centos/) }
  notifies :restart, 'service[docker]', :delayed
end

execute "pull image #{node['docker']['centos_localname']} back" do
  command "docker pull #{node['docker']['centos_localname']}"
  live_stream true
  # not_if { `docker image ls #{node['docker']['centos_localname']}`.match?(/^#{node['hostname']}\:\d+\/centos/) }
  ignore_failure true
  notifies :restart, 'service[docker]', :delayed
end

