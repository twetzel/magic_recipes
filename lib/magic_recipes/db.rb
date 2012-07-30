# encoding: utf-8
module MagicRecipes
  module Db
    def self.load_into(configuration)
      configuration.load do
        
        namespace :db do
          
          desc "seed the database"
          task :seed do
            run <<-CMD
                source '/usr/local/rvm/scripts/rvm' &&
                rvm use 1.9.3 &&
                cd #{latest_release} &&
                #{rake} db:seed RAILS_ENV=#{rails_env}
              CMD
          end
  
          desc "migrate the database"
          task :migrate do
            run <<-CMD
                source '/usr/local/rvm/scripts/rvm' &&
                rvm use 1.9.3 &&
                cd #{latest_release} &&
                #{rake} db:migrate RAILS_ENV=#{rails_env}
              CMD
          end
          
        end
        
        # eof
        
      end
    end
  end
end



        
