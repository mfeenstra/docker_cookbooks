default['user'] = 'matt'

default['docker']['daemonport'] = '2375'
default['docker']['ports'] = [ '2375/tcp', '5000/tcp' ]
default['docker']['pull_centos'] = 'docker pull centos:latest'
default['docker']['centos_localname'] = "#{node['hostname']}.feenstra.io:5000/centos"
default['docker']['pull_registry'] = 'docker run -d -p 5000:5000 --restart=always --name registry registry:2'

# default['docker']['ports'] = [ '2375/tcp', '443/tcp' ]
# default['docker']['centos_localname'] = "#{node['hostname']}.feenstra.io:443/centos"

# default['docker']['pull_registry'] = %( docker run -d --restart=always --name registry -v "$(pwd)"/certs:/certs -e REGISTRY_HTTP_ADDR=0.0.0.0:443 -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key -p 443:443 registry:2 )
 
# default['docker']['execstart'] = "/usr/bin/dockerd --debug --log-level=debug --insecure-registry=#{node['hostname']}:5000 -d fd://"

# default['docker']['service_file'] = '/usr/lib/systemd/system/docker.service'
default['docker']['tcp_listen_uri'] = 'tcp://0.0.0.0:2375'
default['docker']['tag_centos'] = "docker tag centos:latest #{node['docker']['centos_localname']}"


default['docker']['execstart'] = "/usr/bin/dockerd --debug --log-level=debug"
default['docker']['http_proxy'] = "NO_PROXY=#{node['hostname']}.feenstra.io,localhost,127.0.0.1,dcr,dcr.feenstra.io,*.feenstra.io,default-default,0.0.0.0"
