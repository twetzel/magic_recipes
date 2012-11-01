# encoding: utf-8
module MagicRecipes
  # = RVM - Deploy-Recipes
  # 
  # == unused for now
  # 
  # [Tasks:]
  #   
  # 
  # [Callbacks:]
  #   
  # 
  module Nodejs
    def self.load_into(configuration)
      configuration.load do
        
        # code is taken from railscast #337
        
        namespace :nodejs do
          desc "Install the latest relase of Node.js"
          task :install, roles: :app do
            run "#{sudo} add-apt-repository ppa:chris-lea/node.js"
            run "#{sudo} apt-get -y update"
            run "#{sudo} apt-get -y install nodejs"
          end
          after "deploy:install", "nodejs:install"
        end
        
        # eof
        
      end
    end
  end
end


