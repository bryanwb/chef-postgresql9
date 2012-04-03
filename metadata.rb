maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures postgresql for clients or servers"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.100.2"
recipe            "postgresql9", "Includes postgresql::client"
recipe            "postgresql9::client", "Installs postgresql client package(s)"
recipe            "postgresql9::server", "Installs postgresql server packages, templates"
recipe            "postgresql9::server_redhat", "Installs postgresql server packages, redhat family style"
recipe            "postgresql9::server_debian", "Installs postgresql server packages, debian family style"

%w{ ubuntu debian fedora suse }.each do |os|
  supports os
end

%w{redhat centos scientific}.each do |el|
  supports el, ">= 6.0"
end

depends "openssl"
