# encoding: utf-8
module CapistranoMagic
  module Thin
    def self.load_into(configuration)
      configuration.load do
        
        namespace :thin do
          
          desc "rewrite thin-configuration"
          task :reconf, roles: :app do
            template "thin_app_yml.erb", "#{current_path}/config/thin_app.yml"
            run "#{sudo} rm /etc/thin/thin_#{app_name}*"
            run "#{sudo} ln -sf #{current_path}/config/thin_app.yml /etc/thin/thin_#{app_name}.yml"
            # needs nginx_tcp_proxy_module ... https://github.com/yaoweibin/nginx_tcp_proxy_module
            if private_pub_active
              template "thin_private_pub_yml.erb", "#{current_path}/config/thin_pp.yml"
              run "#{sudo} ln -sf #{current_path}/config/thin_pp.yml /etc/thin/thin_#{app_name}_pp.yml"
            end
          end
          
          # Start / Stop / Restart Thin
          %w[start stop restart].each do |command|
            desc "#{command} thin"
            task command, roles: :app do
              reconf
              run <<-CMD
                source '/usr/local/rvm/scripts/rvm' && 
                rvm use 1.9.3 && cd #{current_path} && 
                bundle exec thin #{command} -C config/thin_app.yml
              CMD
            end
            before "nginx:#{command}", "thin:#{command}"
          end
          
        end
        
        # eof
        
      end
    end
  end
end

