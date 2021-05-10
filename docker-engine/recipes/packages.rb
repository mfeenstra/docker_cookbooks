
node['docker']['remove_packages'].each do |p|
  package p do
    action [:remove]
  end
end

node['docker']['packages'].each { |p| package p }
