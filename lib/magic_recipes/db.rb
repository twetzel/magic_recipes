# encoding: utf-8
module MagicRecipes
  module Db
    def self.load_into(configuration)
      configuration.load do
        
        namespace :db do
          
          desc "seed the database"
          task :seed do
            if use_rvm
              run <<-CMD
                source '#{rvm_path}/scripts/rvm' && 
                rvm use #{rvm_ruby}-#{rvm_patch}@#{rvm_gemset} && 
                cd #{latest_release} && 
                #{rake} db:seed RAILS_ENV=#{rails_env}
              CMD
            else
              run "cd #{latest_release} && #{rake} db:seed RAILS_ENV=#{rails_env}"
            end
          end
  
          desc "migrate the database"
          task :migrate do
            if use_rvm
              run <<-CMD
                source '#{rvm_path}/scripts/rvm' && 
                rvm use #{rvm_ruby}-#{rvm_patch}@#{rvm_gemset} && 
                cd #{latest_release} && 
                #{rake} db:migrate RAILS_ENV=#{rails_env}
              CMD
            else
              run "cd #{latest_release} && #{rake} db:migrate RAILS_ENV=#{rails_env}"
            end
          end
          
        end
        
        # eof
        
      end
    end
  end
end



        
