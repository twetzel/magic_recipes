# encoding: utf-8
module MagicRecipes
  # = Assets - Deploy-Recipes
  # 
  # changed asset deployment .. include chmod 777 for public folder (my server need this)
  # 
  # [Tasks:]
  #   :symlink          # => set up a symlink to the shared directory
  # 
  #   :precompile       # => Run the asset precompilation rake task
  # 
  #   :chmod            # => make the public folder public for all (777)
  # 
  #   :clean            # => Run the asset clean rake task
  # 
  # [Callbacks:]
  #   before 'deploy:finalize_update', 'deploy:assets:symlink'
  # 
  #   after 'deploy:update_code', 'deploy:assets:precompile'
  # 
  module Assets
    def self.load_into(configuration)
      configuration.load do
        
        set_default :asset_env, "RAILS_GROUPS=assets"
        set_default :assets_prefix, "assets"
        set_default :assets_role, [:web]

        set_default :normalize_asset_timestamps, false
        set_default :make_pulbic_folder_public, false

        before 'deploy:finalize_update', 'deploy:assets:symlink'
        after 'deploy:update_code', 'deploy:assets:precompile'

        namespace :deploy do
          namespace :assets do
            desc <<-DESC
              [internal] This task will set up a symlink to the shared directory \
              for the assets directory. Assets are shared across deploys to avoid \
              mid-deploy mismatches between old application html asking for assets \
              and getting a 404 file not found error. The assets cache is shared \
              for efficiency. If you customize the assets path prefix, override the \
              :assets_prefix variable to match.
            DESC
            task :symlink, :roles => assets_role, :except => { :no_release => true } do
              run <<-CMD
                #{sudo if use_sudo} rm -rf #{latest_release}/public/#{assets_prefix} &&
                #{sudo if use_sudo} mkdir -p #{latest_release}/public &&
                #{sudo if use_sudo} mkdir -p #{shared_path}/assets &&
                #{sudo if use_sudo} ln -s #{shared_path}/assets #{latest_release}/public/#{assets_prefix}
              CMD
            end

            desc <<-DESC
              Run the asset precompilation rake task. You can specify the full path \
              to the rake executable by setting the rake variable. You can also \
              specify additional environment variables to pass to rake via the \
              asset_env variable. The defaults are:

                set :rake,      "rake"
                set :rails_env, "production"
                set :asset_env, "RAILS_GROUPS=assets"
            DESC
            task :precompile, :roles => assets_role, :except => { :no_release => true } do
              # run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
              if make_pulbic_folder_public
                chmod
              end
              if use_rvm
                run <<-CMD
                    #{rvm_cmd} && 
                    cd #{latest_release} && 
                    #{sudo if use_sudo} #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile
                  CMD
              else
                run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile"
              end
            end
            
            desc "make the public folder public for all (777)"
            task :chmod, :roles => assets_role, :except => { :no_release => true } do
              run "cd #{latest_release} && #{sudo} chmod -R 777 public/ && #{sudo} chmod -R 777 tmp/"
            end

            desc <<-DESC
              Run the asset clean rake task. Use with caution, this will delete \
              all of your compiled assets. You can specify the full path \
              to the rake executable by setting the rake variable. You can also \
              specify additional environment variables to pass to rake via the \
              asset_env variable. The defaults are:

                set :rake,      "rake"
                set :rails_env, "production"
                set :asset_env, "RAILS_GROUPS=assets"
            DESC
            task :clean, :roles => assets_role, :except => { :no_release => true } do
              run "cd #{latest_release} && #{sudo if use_sudo} #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:clean"
            end
          end
        end
        
      end
    end
  end
end




        