#
# Cookbook Name:: postgresql
# Recipe:: server
#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Lamont Granquist (<lamont@opscode.com>)
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "postgresql9::client"

# Create a group and user like the package will.
# Otherwise the templates fail.

package "postgis90"


user "postgres" do
  shell "/bin/bash"
  comment "PostgreSQL Server"
  home "/home/postgres"
  system true
  supports :manage_home => true
end

group "postgres"

package "postgresql90" do
  case node.platform
  when "redhat","centos","scientific"
      package_name "postgresql#{node['postgresql']['version'].split('.').join}"
  else
    package_name "postgresql"
  end
end

case node.platform
when "redhat","centos","scientific"
    package "postgresql#{node['postgresql']['version'].split('.').join}-server"
when "fedora","suse"
  package "postgresql-server"
end

template "/etc/rc.d/init.d/postgresql" do
  source "init.el.erb"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/sysconfig/pgsql/postgresql" do
  source "sysconfig.postgresql.erb"
  owner "root"
  group "root"
  mode 0755
end

directory node['postgresql']['dir'] do
  owner "postgres"
  group "postgres"
  recursive true
  mode 0700
end


service "postgresql" do
  supports :restart => true, :status => true, :reload => true
  action  :enable
end

template "/home/postgres/.bash_profile" do
  source "profile.erb"
  owner "root"
  group "root"
  mode 0775
#  notifies :restart, resources(:service => "postgresql")
end

