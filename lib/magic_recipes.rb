require 'capistrano'

module MagicRecipes
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
      
      set_default :use_rvm,   false           # => no_rvm
      
      def template(from, to)
        erb = File.read(File.expand_path("../magic_recipes/templates/#{from}", __FILE__))
        put ERB.new(erb).result(binding), to
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