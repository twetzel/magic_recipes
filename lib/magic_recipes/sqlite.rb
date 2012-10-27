# encoding: utf-8
module MagicRecipes
  module Sqlite
    def self.load_into(configuration)
      configuration.load do

        set_default :sqlite_path,         "#{ deploy_to }/shared/db/"
        set_default :sqlite_db,           "#{ rails_env.downcase.strip }"

        namespace :sqlite do

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

        # eof
      end
    end
  end
end

