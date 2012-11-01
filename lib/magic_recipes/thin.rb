# encoding: utf-8
module MagicRecipes
  # = Thin - Deploy-Recipes
  # 
  # Simple recipe to work with thin, and app configurstion / registration.
  # 
  # [Tasks:]
  #   :reconf       # => Create or Update the thin yml configuration files
  # 
  #   :start        # => Start the private_pup server
  # 
  #   :stop         # => Start the private_pup server
  # 
  #   :restart      # => Restart the private_pup server
  # 
  # [Callbacks:]
  #   before "nginx:start", "thin:start"
  # 
  #   before "nginx:stop", "thin:stop"
  # 
  module Thin
    def self.load_into(configuration)
      configuration.load do
        
        set_default :thin_path,        '/etc/thin'
        
        namespace :thin do
          
          desc "rewrite thin-configurations"
          task :reconf, roles: :app do
            template "thin_app_yml.erb", "#{current_path}/config/thin_app.yml"
            run "#{sudo} rm -f #{thin_path}/thin_#{app_name}*"
            run "#{sudo} ln -sf #{current_path}/config/thin_app.yml #{thin_path}/thin_#{app_name}.yml"
          end
          
          # Start / Stop / Restart Thin
          %w[start stop restart].each do |command|
            desc "#{command} thin"
            task command, roles: :app do
              reconf
              if use_rvm
                run <<-CMD
                  #{rvm_cmd} && 
                  cd #{current_path} && 
                  bundle exec thin #{command} -C config/thin_app.yml
                CMD
              else
                run "bundle exec thin #{command} -C config/thin_app.yml"
              end
            end
            # before "nginx:#{command}", "thin:#{command}"
          end
          
          before "nginx:start", "thin:start"
          before "nginx:stop", "thin:stop"
          
        end
        
        # eof
        
      end
    end
  end
end

