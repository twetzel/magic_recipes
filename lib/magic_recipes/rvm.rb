# encoding: utf-8
module MagicRecipes
  # = RVM - Deploy-Recipes
  # 
  # little helper to work on crazy rvm mashine ... mine dont accept the standard rvm handling
  # 
  # [Tasks:]
  #   - - -
  # 
  # [Callbacks:]
  #   - - -
  # 
  module Rvm
    def self.load_into(configuration)
      configuration.load do
        
        # => http://stackoverflow.com/questions/7313232/rvm-capistrano-and-bundler-path-issues
        # => http://stackoverflow.com/questions/6968066/confused-by-rvms-instructions-for-capistrano
        
        ## change to rvm-capistrano gem, so commited out
        # $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
        require 'rvm/capistrano'
        
        
        ## Example of new stuff:
        # set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
        # set :rvm_install_ruby_params, '--1.9'      # for jruby/rbx default to 1.9 mode
        # before 'deploy:setup', 'rvm:install_rvm'   # install RVM
        # before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:
        before 'deploy:setup', 'rvm:create_gemset' # only create gemset
        
        
        set_default :rails_env,     'production'
        set_default :rvm_ruby,      '1.9.3'
        set_default :rvm_patch,     'p0'
        set_default :rvm_gemset,    'global'
        set_default :rvm_path,      '/usr/local/rvm'
        
        # set :rvm_type,              :system
        set :rvm_type,              :user
        set :rvm_ruby_string,       "ruby-#{rvm_ruby}-#{rvm_patch}@#{rvm_gemset}"
        set :rvm_bin_path,          "#{rvm_path}/bin"
        set :rvm_lib_path,          "#{rvm_path}/lib"
        set :remote_bin_path,       "#{rvm_path}/gems/ruby-#{rvm_ruby}-#{rvm_patch}/bin/"
        set :use_rvm,               true
        
        set :rvm_cmd,               "source '#{rvm_path}/scripts/rvm' && rvm use #{rvm_ruby}-#{rvm_patch}@#{rvm_gemset}"
        
        # => set :default_environment, {
        # =>   'PATH'            => "#{rvm_path}/gems/ruby/1.9.1/bin:#{rvm_bin_path}/bin:#{remote_bin_path}:$PATH",
        # =>   'RUBY_VERSION'    => "#{rvm_ruby}",
        # =>   'GEM_HOME'        => "#{rvm_path}/gems/#{rvm_ruby_string}",
        # =>   'GEM_PATH'        => "#{rvm_path}/gems/#{rvm_ruby_string}",
        # =>   'BUNDLE_PATH'     => "#{rvm_path}/gems/#{rvm_ruby_string}"
        # => }

        set :bundle_dir,            "#{rvm_path}/gems/#{rvm_ruby_string}"
        set :bundle_flags,          "--deployment --verbose"
        
        namespace :rvm do
          desc "Create gemset"
          rvm_task :create_gemset do
            # run "source '#{rvm_path}/scripts/rvm' && rvm use #{rvm_ruby}-#{rvm_patch}@#{rvm_gemset} --create"
            run "source '#{rvm_path}/scripts/rvm' && rvm use #{rvm_ruby}-#{rvm_patch} && rvm gemset create #{rvm_gemset}"
          end
        end
        
        # eof
        
      end
    end
  end
end



        
