#
# Cookbook:: mexnbox
# Recipe:: react
#
# Copyright:: 2018, The Authors, All Rights Reserved.

bash 'install react' do

  users = Array.new

  if ( node['mexnbox']['react'] ) then

    users = node['mexnbox']['react']['users']

  else

    node['etc']['passwd'].each do | systemuser, data |

      if Dir.exist? '/home/' + systemuser

        users.push(systemuser)

      end

    end

  end

  reactversion = node.read( 'mexnbox', 'react', 'version' ) ? node['mexnbox']['react']['version'] : 'latest'

  for username in users

    if Dir.exist? '/home/' + username

      user username

      cwd '/home/' + username

      environment ({ 'HOME' => ::Dir.home(username), 'USER' => username })

      code <<-EOH

        export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g create-react-app

      EOH

    end

  end

end