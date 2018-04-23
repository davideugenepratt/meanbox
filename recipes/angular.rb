#
# Cookbook:: meanbox
# Recipe:: angular
#
# Copyright:: 2018, The Authors, All Rights Reserved.

bash 'install angular' do

  users = Array.new

  if ( node['meanbox']['angular'] ) then

    users = node['meanbox']['angular']['users']

  else

    node['etc']['passwd'].each do | systemuser, data |

      if Dir.exist? '/home/' + systemuser

        users.push(systemuser)

      end

    end

  end

  angularversion = node.read( 'meanbox', 'angular', 'version' ) ? node['meanbox']['angular']['version'] : 'latest'

  for username in users

    if Dir.exist? '/home/' + username

      user username

      cwd '/home/' + username

      environment ({ 'HOME' => ::Dir.home(username), 'USER' => username })

      code <<-EOH

        export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && npm install -g @angular/cli@#{angularversion}

      EOH

    end

  end

end