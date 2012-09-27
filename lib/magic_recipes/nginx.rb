# encoding: utf-8
module MagicRecipes
  module Nginx
    def self.load_into(configuration)
      configuration.load do
        
        set_default :rails_server,        'thin'
        set_default :http_enabled_path,   '/opt/nginx/http-enabled'
        set_default :tcp_enabled_path,    '/opt/nginx/tcp-enabled'
        set_default :default_site,        false
        
        
        namespace :nginx do
          
          desc "Install latest stable release of nginx"
          task :install, roles: :web do
            run "#{sudo} add-apt-repository ppa:nginx/stable"
            run "#{sudo} apt-get -y update"
            run "#{sudo} apt-get -y install nginx"
          end
          after "deploy:install", "nginx:install"
          
          
          desc "Setup nginx configuration for this application"
          task :setup, roles: :web do
            template "nginx_#{rails_server}.erb", "/tmp/nginx_http_conf"
            run "#{sudo} rm -f #{http_enabled_path}/#{app_name}_*"
            run "#{sudo} mv /tmp/nginx_http_conf #{http_enabled_path}/#{app_name}_#{rails_server}.conf"
          end
          after "deploy:setup", "nginx:setup"
          
          
          %w[start stop].each do |command|
            desc "#{command} nginx"
            task command, roles: :web do
              run "#{sudo} service nginx #{command}"
            end
          end
          
          
          desc "restart nginx-server"
          task :restart, roles: :web do
            setup
            stop
            start
          end
          after "deploy", "nginx:restart"
  
        end
        
        # eof
        
      end
    end
  end
end


