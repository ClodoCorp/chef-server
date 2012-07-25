#
# Author:: Stanislav Bogatyrev <realloc@realloc.spb.ru>
#
# Cookbook Name:: chef
# Recipe:: package-install
#
# Copyright 2012, Clodo.ru
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

case node['platform']
when "debian","ubuntu"
  apt_repository "opscode-chef" do
    uri "http://apt.opscode.com/"
    distribution "#{node['lsb']['codename']}-0.10"
    components ["main"]
    keyserver "keys.gnupg.net"
    key "83EF826A"
    deb_src false
  end

  package "couchdb" do
    action :install
  end

  package "solr-jetty" do
    action :install
  end
  
  bash "enable solr-jetty" do
    user "root"
    code <<-EOH
    sed -i -r "s/NO_START=1/NO_START=0/g" /etc/default/jetty
    EOH
  end
  
  service "jetty" do
    supports :status => true, :restart => true
    action :restart
  end

  package "rabbitmq-server" do
    action :install
  end
  

else
  log("Package installation for #{node['lsb']['codename']} platform is not supported.")
end



