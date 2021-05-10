yum_repository 'docker-ce' do
  description 'docker-ce'
  baseurl node['docker_repo']
  gpgcheck false
  action :create
  ignore_failure true
end
