# encoding: utf-8
module MagicRecipes
  # = Gems - Deploy-Recipes
  # 
  # == Useless .. take the capistrano task
  # 
  module Gems
    def self.load_into(configuration)
      configuration.load do
        
        namespace :gems do
          task :install do
            run "cd #{deploy_to}/current && RAILS_ENV=production bundle install --no-deployment"
          end
        end

        # after :deploy, "gems:install"
        
      end
    end
  end
end

