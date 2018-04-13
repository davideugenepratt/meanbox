#
# Cookbook:: mexnbox
# Recipe:: mongodb
#
# Copyright:: 2018, The Authors, All Rights Reserved.

mongoversion = node.read( 'mexnbox', 'mongodb', 'version' ) ? node['mexnbox']['mongodb']['version'] : false

if node[:platform_family].include?("rhel")

  if mongoversion

    template "/etc/yum.repos.d/mongodb-org-#{mongoversion}.repo" do

      variables( mongoversion: mongoversion )

    end

  else

    cookbook_file '/etc/yum.repos.d/mongodb-org-3.6.repo' do

      source 'mongodb-org-3.6.repo.erb'

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

    if node[:platform].include?("ubuntu") && node[:platform_version].include?("14.04")

      code 'echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list'

    else if node[:platform].include?("ubuntu") && node[:platform_version].include?("16.")

      code 'echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list'

    end

  end

  bash 'reload local package database' do

    code 'sudo apt-get update'

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

end