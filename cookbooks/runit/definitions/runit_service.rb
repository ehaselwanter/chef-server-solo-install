#
# Cookbook Name:: runit
# Definition:: runit_service
#
# Copyright 2008, OpsCode, Inc.
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


define :runit_service, :directory => nil, :only_if => false do
  
  params[:directory] ||= node[:runit_sv_dir]
  
  sv_dir_name = "#{params[:directory]}/#{params[:name]}"

  directory node[:runit_service_dir] do
     mode 0755
     action :create
   end
  
  directory node[:runit_sv_dir] do
     mode 0755
     action :create
   end
 
  directory sv_dir_name do
    mode 0755
    action :create
  end
  
  directory "#{sv_dir_name}/log" do
    mode 0755
    action :create
  end
  
  directory "#{sv_dir_name}/log/main" do
    mode 0755
    action :create
  end
  
  template "#{sv_dir_name}/run" do
    mode 0755
    source "sv-#{params[:name]}-run.erb"
  end
  
  template "#{sv_dir_name}/log/run" do
    mode 0755
    source "sv-#{params[:name]}-log-run.erb"
  end
  
  link "/etc/init.d/#{params[:name]}" do
    to node[:runit_sv_bin]
  end
  
  link "#{node[:runit_service_dir]}/#{params[:name]}" do 
    to "#{sv_dir_name}"
  end
  
  service params[:name] do
    supports :restart => true, :status => true
    action :nothing
  end
  
  #execute "#{params[:name]}-down" do
  #  command "/etc/init.d/#{params[:name]} down"
  #  only_if do params[:only_if] end
  #end
  
end
