#
# Cookbook Name:: lamp-main
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Initialize sites data bag
sites = []
begin
  sites = data_bag("sites")
rescue
  puts "Unable to load sites data bag."
end

# Configure sites
sites.each do |name|
  site = data_bag_item("sites", name)

  # Add site to apache config
  web_app site["host"] do
    template "sites.conf.erb"
    server_name site["host"]
    server_aliases site["aliases"]
    server_include site["include"]
    docroot site["docroot"]?site["docroot"]:"/vagrant/public/#{site["host"]}"
  end

   # Add site info in /etc/hosts
   bash "hosts" do
     code "echo 127.0.0.1 #{site["host"]} #{site["aliases"].join(' ')} >> /etc/hosts"
   end
end

# Disable default site
apache_site "default" do
  enable false
end

# Install phpmyadmin
cookbook_file "/tmp/phpmyadmin.deb.conf" do
  source "phpmyadmin.deb.conf"
end
bash "debconf_for_phpmyadmin" do
  code "debconf-set-selections /tmp/phpmyadmin.deb.conf"
end
package "phpmyadmin"

# Install Xdebug
php_pear "xdebug" do
  action :install
end
template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end

# Install Webgrind
git "/var/www/webgrind" do
  repository 'git://github.com/jokkedk/webgrind.git'
  reference "master"
  action :sync
end
template "#{node[:apache][:dir]}/conf.d/webgrind.conf" do
  source "webgrind.conf.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end
template "/var/www/webgrind/config.php" do
  source "webgrind.config.php.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
end