# encoding: utf-8
module MagicRecipes
  # = Postgresql - Deploy-Recipes
  # 
  # Some simple recipes for PostgreSQL
  # 
  # [Tasks:]
  #   :install                      # => Install the latest stable release of PostgreSQL.
  # 
  #   :create_database              # => Create database and user for this application.
  # 
  #   :setup                        # => Generate the database.yml configuration file.
  # 
  #   :symlink                      # => Symlink the database.yml file into latest release
  # 
  #   :kill_postgres_connections    # => kill pgsql users so database can be dropped
  # 
  #   :drop_public_shema            # => drop public shema so db is empty and not dropped
  # 
  #   :create_user                  # => Create a postgres-user for this application.
  # 
  #   :drop_user                    # => Drop the postgres-user for this application.
  # 
  #   :create_db                    # => Create only a database for this application.
  # 
  #   :drop_database                # => Drop the postgres-database for this application.
  # 
  # [Callbacks:]
  #   after "deploy:install", "postgresql:install"
  # 
  #   after "deploy:setup", "postgresql:create_database"
  # 
  #   after "deploy:setup", "postgresql:setup"
  # 
  #   after "deploy:finalize_update", "postgresql:symlink"
  # 
  module Postgresql
    def self.load_into(configuration)
      configuration.load do
        
        # code is taken from railscast #337
        
        set_default(:postgresql_host, "localhost")
        set_default(:postgresql_user) { application }
        set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
        set_default(:postgresql_database) { "#{application}_#{rails_env}" }
        set_default(:postgresql_pool, 5)
        
        namespace :postgresql do
          desc "Install the latest stable release of PostgreSQL."
          task :install, roles: :db, only: {primary: true} do
            run "#{sudo} wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -"
            run "#{sudo} apt-get -y update"
            run "#{sudo} apt-get -y install postgresql"
            # add constrib for hstore extension
            run "#{sudo} apt-get -y install postgresql-contrib"
          end
          after "deploy:install", "postgresql:install"
          
          desc "Create a database and user for this application."
          task :create_database, roles: :db, only: {primary: true} do
            # make a superuser .. to be able to install extensions like hstore
            run %Q{#{sudo} -u postgres psql -c "CREATE ROLE #{postgresql_user} WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD '#{postgresql_password}';"}
            #run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
            run %Q{#{sudo} -u postgres psql -c "CREATE DATABASE #{postgresql_database} WITH OWNER #{postgresql_user};"}
          end
          after "deploy:setup", "postgresql:create_database"
          
          desc "Create a postgres-user for this application."
          task :create_user, roles: :db, only: {primary: true} do
            # make a superuser .. to be able to install extensions like hstore
            run %Q{#{sudo} -u postgres psql -c "CREATE ROLE #{postgresql_user} WITH SUPERUSER CREATEDB CREATEROLE LOGIN ENCRYPTED PASSWORD '#{postgresql_password}';"}
          end
          
          desc "Drop the postgres-user for this application."
          task :drop_user, roles: :db, only: {primary: true} do
            # make a superuser .. to be able to install extensions like hstore
            run %Q{#{sudo} -u postgres psql -c "DROP ROLE #{postgresql_user};"}
          end
          
          desc "Create only a database for this application."
          task :create_db, roles: :db, only: {primary: true} do
            run %Q{#{sudo} -u postgres psql -c "CREATE DATABASE #{postgresql_database} WITH OWNER #{postgresql_user};"}
          end
          
          desc "Drop the postgres-database for this application."
          task :drop_database, roles: :db, only: {primary: true} do
            # make a superuser .. to be able to install extensions like hstore
            run %Q{#{sudo} -u postgres psql -c "DROP DATABASE #{postgresql_database};"}
          end
          
          desc "Generate the database.yml configuration file."
          task :setup, roles: :app do
            run "mkdir -p #{shared_path}/config"
            template "postgresql.yml.erb", "#{shared_path}/config/postgres_#{rails_env}.yml"
          end
          after "deploy:setup", "postgresql:setup"
          
          desc "Symlink the database.yml file into latest release"
          task :symlink, roles: :app do
            run "ln -nfs #{shared_path}/config/postgres_#{rails_env}.yml #{release_path}/config/database.yml"
          end
          after "deploy:finalize_update", "postgresql:symlink"
          
          # http://stackoverflow.com/a/12939218/1470996
          desc 'kill pgsql users so database can be dropped'
          task :kill_postgres_connections do
            run %Q{#{sudo} -u postgres psql -c "SELECT pg_terminate_backend(procpid) FROM pg_stat_activity WHERE datname='#{postgresql_database}';"}
          end
          
          
          
          desc 'drop public shema so db is empty and not dropped'
          task :drop_public_shema do
            run %Q{#{sudo} -u postgres psql -c "drop schema public cascade on #{postgresql_database};';"}
          end
          
        end
        
        # eof
        
      end
    end
  end
end

        