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
                #{rvm_cmd} && 
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
                #{rvm_cmd} && 
                cd #{latest_release} && 
                #{rake} db:migrate RAILS_ENV=#{rails_env}
              CMD
            else
              run "cd #{latest_release} && #{rake} db:migrate RAILS_ENV=#{rails_env}"
            end
          end
          
          desc "delete all tables of the database"
          task :delete_tables do
            if use_rvm
              run <<-CMD
                #{rvm_cmd} && 
                cd #{latest_release} && 
                ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }
              CMD
            else
              run "cd #{latest_release} && ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }"
            end
          end
          
        end
        
        # eof
        
      end
    end
  end
end



        
