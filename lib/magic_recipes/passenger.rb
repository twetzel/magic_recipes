# encoding: utf-8
module MagicRecipes
  module Passenger
    def self.load_into(configuration)
      configuration.load do
        
        namespace :passenger do
          
          # Restart Passenger
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


