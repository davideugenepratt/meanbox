#
# Cookbook:: meanbox
# Recipe:: mongodb
#
# Copyright:: 2018, The Authors, All Rights Reserved.

mongoversion = node.read('meanbox', 'mongodb', 'version') ? node['meanbox']['mongodb']['version'] : false

if node['platform'] == 'redhat' || node['platform'] == 'centos'
  if mongoversion
    template "/etc/yum.repos.d/mongodb-org-#{mongoversion}.repo" do
      source 'mongodb-org.repo.erb'
      variables(mongoversion: mongoversion)
    end
  else
    cookbook_file '/etc/yum.repos.d/mongodb-org-3.6.repo' do
      source 'mongodb-org-3.6.repo'
      action :create
    end
  end
  bash 'install mongodb-org packages' do
    if mongoversion
      code "yum install -y mongodb-org=#{mongoversion} mongodb-org-server=#{mongoversion} mongodb-org-shell=#{mongoversion} mongodb-org-mongos=#{mongoversion} mongodb-org-tools=#{mongoversion}"
    else
      code 'yum install -y mongodb-org'
    end
  end
else
  bash 'import public key' do
    code 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5'
  end

  bash 'create list file for mongodb' do
    if node['platform'].include?('ubuntu') == true
      case node['platform_version']

      when '14.04'
        code 'echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list'
      when '16.04'
        code 'echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list'
      else
        code ''
        Chef::Log.error('This version of Ubuntu is not supported by MongoDB')
      end
    end
  end

  bash 'reload local package database' do
    code 'apt-get -y update'
  end

  bash 'install mongodb-org packages' do
    if mongoversion
      code "apt-get install -y mongodb-org=#{mongoversion} mongodb-org-server=#{mongoversion} mongodb-org-shell=#{mongoversion} mongodb-org-mongos=#{mongoversion} mongodb-org-tools=#{mongoversion}"
    else
      code 'apt-get install -y mongodb-org'
    end
  end
end

service 'mongod' do
  action :enable
end

service 'mongod' do
  action :start
end
