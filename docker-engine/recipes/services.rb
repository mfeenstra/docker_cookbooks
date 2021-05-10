node['docker']['services'].each do |s|
  service s do
    action [:enable, :start]
  end
end
