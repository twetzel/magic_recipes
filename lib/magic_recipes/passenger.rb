# encoding: utf-8
module MagicRecipes
  # = Passenger - Deploy
  # 
  # Simple recipe to restart passenger
  # 
  # [Tasks:]
  #   task :restart   # => Restart Phusion-Passenger
  # 
  # [Callbacks:]
  #   after "deploy:restart", "passenger:restart"
  # 
  module Passenger
    
    def self.load_into(configuration)
      configuration.load do
        
        set_default :pre_start, false         # => pre_start the first domain ?
        
        namespace :passenger do
          
          desc "Restart - Passenger"
          task :restart, :roles => :app, :except => { :no_release => true } do
            run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
          end
          after "deploy:restart", "passenger:restart"
          
        end
        
      end
    end
  end
end


