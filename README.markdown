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


## ToDo´s

- add tests (rspec+cucumber)
- make expect-cap-task (bin/*_cap)

- improve: passenger, unicorn rbenv, postgesql, nodejs, gems, db, git, rvm
- add: puma, varnish, search-stuff, vps-stuff


## Ready

and in use .. but not tested

- nginx
- thin
- assets
- private_pub ... needs [nginx_tcp_proxy_module](https://github.com/yaoweibin/nginx_tcp_proxy_module) for nginx

### Licence
This project rocks and uses MIT-LICENSE.