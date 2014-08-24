name             'lamp-main'
maintainer       'Webgig'
maintainer_email 'webgig.sagar@gmail.com'
license          'All rights reserved'
description      'Installs/Configures phpapp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'


depends "apt"
depends "build-essential"
depends "git"
depends "apache2"
depends "apache2::mod_rewrite"
depends "apache2::mod_ssl"
depends "mysql::server"
depends "php"
depends "php::module_mysql"
depends "php::module_apc"
depends "php::module_curl"
depends "apache2::mod_php5"
depends "composer"


