# MagicRecipes

.. some capistrano-recipes for our deployment .. still in development.

Code is inspired by:

- [Ryan Bates](https://github.com/ryanb) .. [railscast #337](http://railscasts.com/episodes/337-capistrano-recipes) = some of the recipes

- [Sergey Nartimov](https://github.com/lest/capistrano-deploy) = the load mechanism

## Usage

- add magic_recipes to your Gemfile

    gem 'magic_recipes', :require => nil

- run bundle install
- run the generator

    rails g magic_recipes:capify

- edit 'config/deploy'
- enjoy some magic


This project rocks and uses MIT-LICENSE.