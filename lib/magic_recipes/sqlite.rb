# encoding: utf-8
module MagicRecipes
  # = RVM - Deploy-Recipes
  # 
  # This is more for test & try pupose. Save .sqlite and copy to current after deploy.
  # 
  # [Tasks:]
  #   :setup_db       # => Create shared folder.
  # 
  #   :save_db        # => Copy current DB to shared folder.
  # 
  #   :copy_db        # => Copy saved DB from shared folder to current_release
  # 
  # [Callbacks:]
  #   after "deploy:setup", "sqlite:setup_db"
  # 
  #   more in deploy.rb ! .. becasuse ist just in case you need it .. and only works after second deploy !
  # 
  module Sqlite
    def self.load_into(configuration)
      configuration.load do

        set_default :sqlite_path,         "#{ deploy_to }/shared/db/"
        set_default :sqlite_db,           "#{ rails_env.downcase.strip }"

        namespace :sqlite do
          
          desc "setup shared sqlite-folder"
          task :setup_db do
            run "mkdir #{ sqlite_path }"
          end

          desc "save current db"
          task :save_db do
            if use_rvm
              run <<-CMD
                #{rvm_cmd} && 
                cd #{deploy_to}/current/db && 
                cp -f #{ sqlite_db }.sqlite3 #{ sqlite_path }/
              CMD
            else
              run "cd #{deploy_to}/current/db && cp #{ sqlite_db }.sqlite3 #{sqlite_path}/"
            end
          end

          desc "copy the database"
          task :copy_db do
            if use_rvm
              run <<-CMD
                #{rvm_cmd} && 
                cd #{sqlite_path} && 
                cp -f #{ sqlite_db }.sqlite3 #{deploy_to}/current/db/
              CMD
            else
              run "cd #{sqlite_path} && cp -f #{ sqlite_db }.sqlite3 #{deploy_to}/current/db/"
            end
          end

        end

        after "deploy:setup", "sqlite:setup_db"

        # eof
      end
    end
  end
end

