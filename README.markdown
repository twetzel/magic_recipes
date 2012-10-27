# MagicRecipes

Some capistrano-recipes for our deployment .. still in development!

Code is inspired by:

- [Ryan Bates](https://github.com/ryanb) .. [railscast #337](http://railscasts.com/episodes/337-capistrano-recipes) = some of the recipes

- [Sergey Nartimov](https://github.com/lest/capistrano-deploy) = the load mechanism


## Usage

add magic_recipes to your Gemfile
```ruby
gem 'magic_recipes', :require => nil
```

install the gem
```ruby
$ bundle install
```

run the generator
```ruby
$ rails g magic_recipes:capify
```

edit 'config/deploy'

enjoy some magic!


## ToDo´s

- add tests (rspec+cucumber)
- make expect-cap-task (bin/*_cap)
- **improve:** passenger, unicorn rbenv, postgesql, nodejs, gems, db, git, rvm
- **add:** puma, varnish, search-stuff, vps-stuff


## Ready

and in use .. but not tested

- nginx
- thin
- assets
- private_pub ... needs [nginx_tcp_proxy_module](https://github.com/yaoweibin/nginx_tcp_proxy_module) for nginx
- *sqlite* ... this is more for test & try pupose (save .sqlite and copy to current after deploy)


## More .. ( special feature )

There's also an Except-Script (bin/git_cap) which is great if you use a private-git-repository ... so you don't need to provide your git-username and git-password twice every deploy.

**Usage**

```ruby
$ rails g magic_recipes:git_cap 				# => from app folder .. copy git_cap file
$ git_cap git_name git_password 				# => from app folder .. start silent depoy
```

or add an alias in ~/.profile | ~/.bash_rc
```ruby
alias git_deploy='./git_cap git_name git_password'
```

and start with
```ruby
$ git_deploy
```

### Licence
This project rocks and uses MIT-LICENSE.