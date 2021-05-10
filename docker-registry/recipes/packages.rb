
node['docker_remove_packages'].each do |p|
  package p do
    action [:remove]
  end
end

node['docker_packages'].each { |p| package p }
