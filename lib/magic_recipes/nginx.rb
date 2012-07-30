# encoding: utf-8
module CapistranoMagic
  module Nginx
    def self.load_into(configuration)
      configuration.load do
        
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
            run "#{sudo} rm /opt/nginx/http-enabled/#{app_name}_*"
            run "#{sudo} mv /tmp/nginx_http_conf /opt/nginx/http-enabled/#{app_name}_#{rails_server}.conf"
    
            # needs nginx_tcp_proxy_module ... https://github.com/yaoweibin/nginx_tcp_proxy_module
            if private_pub_active
              template "nginx_private_pub.erb", "/tmp/nginx_tcp_conf"
              template "thin_private_pub_yml.erb", "#{current_path}/config/thin_pp.yml"
              run "#{sudo} mv /tmp/nginx_tcp_conf /opt/nginx/tcp-enabled/#{app_name}_private_pub.conf"
              run "#{sudo} ln -sf #{current_path}/config/thin_pp.yml /etc/thin/thin_#{app_name}_pp.yml"
            end
    
            # run "#{sudo} mv /tmp/nginx_conf /opt/nginx/sites-enabled/#{application}"
            # run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
            # stop
            # start
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


