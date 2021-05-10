open_ports = `firewall-cmd --list-ports`.split(' ') || ''

node['docker']['ports'].each do |port|

  execute "open firewall (#{port}) for docker registry" do
    command "firewall-cmd --add-port=#{port} --zone=public --permanent"
    live_stream true
    ignore_failure true
    not_if { open_ports.include?(port) }
    notifies :run, 'execute[reload_firewall]', :delayed
  end

end
  
execute 'reload_firewall' do
  command 'firewall-cmd --reload'
  live_stream true
  ignore_failure true
  returns [0, 1, 252]
  action [:nothing]
end
