# encoding: utf-8
require 'rails/generators'

module MagicRecipes
  module Generators
    class CapifyGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      include Thor::Actions

      desc "Some visuals."
      def initial_desc
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
        puts('   -   -   -   -   -   -   -   -   M A G I C - R E C I P E S   -   -   -   -   -   -   -   -   -   -   -')
      end
      
      
      
      def create_root_files
        if File.exists?( "#{ Rails.root }/Capfile" )
          File.rename("#{ Rails.root }/Capfile", "#{ Rails.root }/Capfile.old")
        end
        if File.exists?( "#{ Rails.root }/config/deploy.rb" )
          File.rename("#{ Rails.root }/config/deploy.rb", "#{ Rails.root }/config/deploy.rb.old")
        end
        template "Capfile.tt", "#{ Rails.root }/Capfile"
        template "deploy.rb.tt", "#{ Rails.root }/config/deploy.rb"
      end
      
      
      
      def end_desc
        puts("   -   -   -   -   -   -   -   -   you are ready for magic!    -   -   -   -   -   -   -   -   -   -   -")
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
      end
      
      
      
    end
  end
end