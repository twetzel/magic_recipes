# encoding: utf-8
module MagicRecipes
  module PrivatePub
    def self.load_into(configuration)
      configuration.load do
        
        set_default :private_pub_domain, "0.0.0.0"            # => private_pub domain
        #set_default :private_pub_instances, 1                # => private_pub server instances .. for now only 1 !
        set_default :private_pub_host, 9200                   # => public port
        set_default :private_pub_port, 9292                   # => intern port
        set_default(:private_pub_key, "882293e492b7e7a2fed266a5f38062420e12fb75eae5f145e256af60dc9681bc")

        namespace :private_pub do
          
          # needs nginx_tcp_proxy_module ... https://github.com/yaoweibin/nginx_tcp_proxy_module
          desc "reconf private_pub .. "
          task :reconf do
            template "thin_private_pub_yml.erb", "#{current_path}/config/thin_pp.yml"
            run "#{sudo} ln -sf #{current_path}/config/thin_pp.yml #{thin_path}/thin_#{app_name}_pp.yml"
          end
          
          
          desc "setup private_pub .. "
          task :setup do
            reconf
            template "nginx_private_pub.erb", "/tmp/nginx_tcp_conf"
            run "#{sudo} mv /tmp/nginx_tcp_conf #{tcp_enabled_path}/#{app_name}_private_pub.conf"
          end
          
          
          desc "write config/private_pup.yml"
          task :yml_file do
            template "private_pub_yml.erb", "#{current_path}/config/private_pub.yml"
          end
          
          
          desc "start private_pub server"
          task :start, roles: :app do
            # => run <<-CMD
            # =>     source '/usr/local/rvm/scripts/rvm' && 
            # =>     rvm use 1.9.3 && 
            # =>     cd #{current_path} && 
            # =>     RAILS_ENV=production bundle exec rackup private_pub.ru -s thin -E production -p #{private_pub_port} -o #{server_ip} -D
            # =>   CMD
            run "cd #{current_path} && RAILS_ENV=production bundle exec rackup private_pub.ru -s thin -E production -p #{private_pub_port} -o #{server_ip} -D"
          end
          
          
          desc "stop private_pub server"
          task :stop, roles: :app do
            run "if [ `lsof -t -i:#{private_pub_port}` ]; then #{sudo} kill $(#{sudo} lsof -t -i:#{private_pub_port}); fi"
          end
          
          
          desc "restart private_pub server"
          task :restart, roles: :app do
            stop
            start
          end
          
          
          before "thin:start", "private_pub:yml_file"
          after "thin:start", "private_pub:start"
          after "thin:stop", "private_pub:stop"
          after "nginx:setup", "private_pub:setup"
          after "thin:reconf", "private_pub:reconf"
          
          
        end
        
        # eof
        
      end
    end
  end
end

