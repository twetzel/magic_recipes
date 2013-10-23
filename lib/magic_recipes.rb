require 'capistrano'

module MagicRecipes
  # = MagicRecipes
  # 
  # Some capistrano-recipes for our deployment .. still in development!
  # 
  # [Methods:]
  #   template(from, to)                  # => write erb template to path
  # 
  #   set_default(name, *args, &block)    # => set default value
  # 
  #   random_string(length=42)            # => generate a random string
  # 
  #   use_recipe(recipe_name)             # => load one recipe
  # 
  #   magic_recipes(*recipes)             # => load several recipes
  # 
  # [Usage:]
  #   add magic_recipes to your Gemfile
  #     gem 'magic_recipes', :require => nil
  # 
  #   install the gem
  #     bundle install
  # 
  #   run the generator
  #     rails g magic_recipes:capify
  # 
  #   edit 'config/deploy'
  # 
  #   enjoy some magic!
  # 
  # [config/deploy.rb:]
  # 
  #   uncomment and edit all needed vars
  # 
  #   add all recipes
  #     magic_recipes :assets, :db, :nginx, :postgresql, :private_pub, :rvm, :sqlite, :thin
  # 
  #   add your recipes
  #     magic_recipes :assets, :nginx, :rvm, :thin
  # 
  def self.load_into(configuration)
    configuration.load do
      
      @magical_recipes = []

      class << self
        attr_reader :magical_recipes
      end
      
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
      # Magic-Helper:
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
      
      require 'bundler/capistrano'
      
      default_run_options[:pty] = true
      ssh_options[:forward_agent] = true
      
      # default put_via sftp
      set_default :put_via,   :sftp           # => :sftp | :scp
      
      def template(from, to)
        erb = File.read(File.expand_path("../magic_recipes/templates/#{from}", __FILE__))
        put ERB.new(erb).result(binding), to, via: put_via
      end

      def set_default(name, *args, &block)
        set(name, *args, &block) unless exists?(name)
      end

      def random_string(length=42)
        # chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
        chars = 'abcdefghjkmnpqrstuvwxyz234567890'
        password = ''
        length.times { password << chars[rand(chars.size)] }
        password
      end
      
      
      set_default :use_rvm,   false           # => no_rvm
      
      namespace :deploy do
        desc "Install everything onto the server"
        task :install do
          run "#{sudo} apt-get -y update"
          run "#{sudo} apt-get -y install python-software-properties"
        end
      end
      
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
      # Load-Helper:
      # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
      
      def use_recipe(recipe_name)
        return if @magical_recipes.include?(recipe_name.to_sym)

        begin
          require "magic_recipes/#{recipe_name.to_s}"

          recipe = ::MagicRecipes.const_get( recipe_name.to_s.capitalize.gsub(/_(\w)/) { $1.upcase } )
          recipe.load_into(self)
          @magical_recipes << recipe_name.to_sym
        rescue LoadError
          abort "There is no recipe called `#{recipe_name}`!"
        end
      end

      def magic_recipes(*recipes)
        recipes.map{ |recipe| use_recipe(recipe) }
      end

    end
  end
end

if Capistrano::Configuration.instance
  MagicRecipes.load_into(Capistrano::Configuration.instance)
end