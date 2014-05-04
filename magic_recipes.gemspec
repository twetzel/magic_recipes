$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "magic_recipes"
  s.version     = "0.1.13"
  s.authors     = ["torsten wetzel"]
  s.email       = ["torstenwetzel@berlinmagic.com"]
  s.license     = 'MIT'
  s.homepage    = "http://berlinmagic.com"
  s.summary     = "MagicRecipes .. some capistrano recipes for our deployment."
  s.description = "Our capistrano recipes for nginx, passenger, thin, private_pub, .. include expect-script for silent-deployment of private git-repos."

  s.files = Dir["{bin,lib,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]

  # => s.add_dependency "rails",           "~> 3.2.6"
  # => # s.add_dependency "capistrano",    "~> 2.12.0" .. doesnt work
  # => s.add_dependency "capistrano",      "2.9.0"
  # => s.add_dependency "rvm-capistrano",  "1.2.7"
  
  # => s.add_dependency "rails",           "~> 4.0.0"
  s.add_dependency "rails",           ">=  3.2.6"
  s.add_dependency "capistrano"
  s.add_dependency "rvm-capistrano"
  
  
  # => Add Test-Dependencies
  s.add_development_dependency "rspec-rails"
  
end
