#
# Cookbook:: meanbox
# Recipe:: grunt
#
# Copyright:: 2018, The Authors, All Rights Reserved.


bash 'install grunt' do

  users = Array.new

  if node.read( 'meanbox', 'grunt', 'users' ) then

    users = node['meanbox']['grunt']['users']

  else

    node['etc']['passwd'].each do | systemuser, data |

      if Dir.exist? '/home/' + systemuser

        users.push(systemuser)

      end

    end

  end

  for username in users

    if Dir.exist? '/home/' + username

      user username

      cwd '/home/' + username

      environment ({ 'HOME' => ::Dir.home(username), 'USER' => username })

      code <<-EOH

        export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g grunt

      EOH

    end

  end

end