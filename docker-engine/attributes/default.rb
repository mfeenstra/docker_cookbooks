default['docker']['user'] = 'matt'

default['docker']['registry'] = 'dcr.feenstra.io:5000'

default['docker']['service_file'] = '/usr/lib/systemd/system/docker.service'
default['docker']['tcp_listen_uri'] = 'tcp://127.0.0.1:2375'

default['docker']['ports'] = [ '2375/tcp' ]
