# encoding: utf-8
module CapistranoMagic
  module Assets
    def self.load_into(configuration)
      configuration.load do
        
        set_default :asset_env, "RAILS_GROUPS=assets"
        set_default :assets_prefix, "assets"
        set_default :assets_role, [:web]

        set_default :normalize_asset_timestamps, false

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
                rm -rf #{latest_release}/public/#{assets_prefix} &&
                mkdir -p #{latest_release}/public &&
                mkdir -p #{shared_path}/assets &&
                ln -s #{shared_path}/assets #{latest_release}/public/#{assets_prefix}
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
              run <<-CMD
                source '/usr/local/rvm/scripts/rvm' &&
                rvm use 1.9.3 &&
                cd #{latest_release} &&
                #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile && 
                #{sudo} chmod -R 777 public/ &&
                #{sudo} chmod -R 777 tmp/
              CMD
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
              run "cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:clean"
            end
          end
        end
        
      end
    end
  end
end




        