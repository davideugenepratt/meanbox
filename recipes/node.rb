#
# Cookbook:: mexnbox
# Recipe:: node
#
# Copyright:: 2018, The Authors, All Rights Reserved.


bash 'install nvm' do

  users = Array.new

  if ( node['mexnbox']['node'] ) then

    users = node['mexnbox']['node']['users']

  else

    Chef::Log.info( "no json" )

    node['etc']['passwd'].each do | systemuser, data |

      if Dir.exist? '/home/' + systemuser

        users.push(systemuser)

      end

    end

  end

  nodeversion = node['mexnbox']['node']['version'] ? node['mexnbox']['node']['version'] : 'node'

  for username in users

    if Dir.exist? '/home/' + username

      user username

      cwd '/home/' + username

      environment ({ 'HOME' => ::Dir.home(username), 'USER' => username })

      code <<-EOH

        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
        export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install #{nodeversion} && nvm use #{nodeversion}

      EOH

    end

  end

end