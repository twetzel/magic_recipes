# encoding: utf-8
module MagicRecipes
  # = Db - Deploy-Recipes
  # 
  # Some recipes to work with databases, especialy when you have an server, where you can't delete or create db's.
  # 
  # [Tasks:]
  #   :seed           # => seed the database
  # 
  #   :migrate        # => migrate the database
  # 
  #   :delete_tables  # => delete all Tables of the Database!
  # 
  #   :save_reset     # => DB-Reset for user without dbcreate permission (deletes all tables than migrates again)
  # 
  # [Callbacks:]
  #   - - -
  # 
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
          
          desc "delete all Tables of the Database!"
          task :delete_tables do
            if use_rvm
              run <<-CMD
                #{rvm_cmd} && 
                cd #{latest_release} && 
                RAILS_ENV=#{rails_env} rails runner "ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }"
              CMD
            else
              run "cd #{latest_release} && RAILS_ENV=#{rails_env} rails runner 'ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }'"
            end
            # => ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }
          end
          
          desc "DB-Reset for user without dbcreate permission (deletes all tables than migrates again)"
          task :save_reset do
            delete_tables
            migrate
          end
          
        end
        
        # eof
        
      end
    end
  end
end



        
