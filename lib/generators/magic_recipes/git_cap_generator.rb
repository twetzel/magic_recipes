# encoding: utf-8
require 'rails/generators'

module MagicRecipes
  module Generators
    class GitCapGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      include Thor::Actions

      # => argument :git_name,       :type => :string, :banner => 'GitName',     :default => "git_name"
      # => argument :git_password,   :type => :string, :banner => 'GitPassword', :default => "git_password"
      # => def initialize(args, *options) #:nodoc:
      # =>   super
      # => end

      desc "Some visuals."
      def initial_desc
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
        puts('   -   -   -   -   -   -   M A G I C - R E C I P E S : git-deploy-helper   -   -   -   -   -   -   -   -')
      end

      desc "copy git_cap file."
      def create_git_cap_files
        template "git_cap.tt", "#{ Rails.root }/git_cap"
      end

      desc "More visuals."
      def end_desc
        puts("   -   -   -   -   -   -    Usage:  $ git_cap [git_name] [git_password]    -   -   -   -   -   -   -   -")
        puts('   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *   *')
      end

    end
  end
end