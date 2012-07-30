# encoding: utf-8
module MagicRecipes
  module Rvm
    def self.load_into(configuration)
      configuration.load do
        
        # => http://stackoverflow.com/questions/7313232/rvm-capistrano-and-bundler-path-issues
        $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
        require 'rvm/capistrano'
        
        set_default :rails_env,     'production'
        set_default :rvm_ruby,      '1.9.3'
        set_default :rvm_patch,     'p0'
        set_default :rvm_gemset,    'global'
        set_default :rvm_path,      '/usr/local/rvm'
        set :rvm_type,              :system
        set :rvm_ruby_string,       "ruby-#{rvm_ruby}-#{rvm_patch}@#{rvm_gemset}"
        set :rvm_path,              "/usr/local/rvm"
        set :rvm_bin_path,          "#{rvm_path}/bin"
        set :rvm_lib_path,          "#{rvm_path}/lib"
        set :remote_bin_path,       "#{rvm_path}/gems/ruby-#{rvm_ruby}-#{rvm_patch}/bin/"

        set :default_environment, {
          'PATH'            => "#{rvm_path}/gems/ruby/1.9.1/bin:#{rvm_bin_path}/bin:#{remote_bin_path}:$PATH",
          'RUBY_VERSION'    => "#{rvm_ruby}",
          'GEM_HOME'        => "#{rvm_path}/gems/#{rvm_ruby_string}",
          'GEM_PATH'        => "#{rvm_path}/gems/#{rvm_ruby_string}",
          'BUNDLE_PATH'     => "#{rvm_path}/gems/#{rvm_ruby_string}"
        }

        set :bundle_dir,            "#{rvm_path}/gems/#{rvm_ruby_string}"
        set :bundle_flags,          "--deployment --verbose"
        
        # eof
        
      end
    end
  end
end



        
