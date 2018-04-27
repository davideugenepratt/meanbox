#
# Cookbook:: meanbox
# Recipe:: grunt
#
# Copyright:: 2018, The Authors, All Rights Reserved.

bash 'install grunt' do
  users = []

  if node.read 'meanbox', 'grunt', 'users'
    users = node['meanbox']['grunt']['users']
  else
    node['etc']['passwd'].each do |systemuser, _data|
      users.push(systemuser) if Dir.exist? '/home/' + systemuser
    end
  end

  users.each do |username, _data|
    next unless Dir.exist? '/home/' + username

    user username

    cwd '/home/' + username

    environment('HOME' => ::Dir.home(username), 'USER' => username)

    code <<-EOH

      export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g grunt

    EOH
  end
end
