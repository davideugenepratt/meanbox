#
# Cookbook:: meanbox
# Recipe:: express
#
# Copyright:: 2018, The Authors, All Rights Reserved.

bash 'install express' do
  users = []

  if node.read 'meanbox', 'express'
    users = node['meanbox']['express']['users']
  else
    node['etc']['passwd'].each do |systemuser, _data|
      users.push(systemuser) if Dir.exist? '/home/' + systemuser
    end
  end

  expressversion = node.read('meanbox', 'express', 'version') ? node['meanbox']['express']['version'] : '4'

  users.each do |username, _data|
    next unless Dir.exist? '/home/' + username

    Chef::Log.info('hasdir' + username)

    user username

    cwd '/home/' + username

    environment('HOME' => ::Dir.home(username), 'USER' => username)

    code <<-EOH
      export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g express-generator@#{expressversion}

    EOH
  end

end
