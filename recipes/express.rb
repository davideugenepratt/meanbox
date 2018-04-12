#
# Cookbook:: mexnbox
# Recipe:: express
#
# Copyright:: 2018, The Authors, All Rights Reserved.


bash 'install express' do

  users = Array.new

  if ( node['mexnbox']['express'] ) then

    users = node['mexnbox']['express']['users']

  else

    node['etc']['passwd'].each do | systemuser, data |

      if Dir.exist? '/home/' + systemuser

        users.push(systemuser)

      end

    end

  end

  expressversion = node.read( 'mexnbox', 'express', 'version' ) ? node['mexnbox']['express']['version'] : '4'

  for username in users

    if Dir.exist? '/home/' + username

      user username

      cwd '/home/' + username

      environment ({ 'HOME' => ::Dir.home(username), 'USER' => username })

      code <<-EOH

        export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g express-generator@#{expressversion}

      EOH

    end

  end

end