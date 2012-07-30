$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "magic_recipes"
  s.version     = "0.0.2"
  s.authors     = ["torsten wetzel"]
  s.email       = ["torstenwetzel@berlinmagic.com"]
  s.homepage    = "http://berlinmagic.com"
  s.summary     = "MagicRecipes .. some capistrano recipes for our deployment."
  s.description = "Our capistrano recipes for nginx, passenger, thin, private_pub .. some code is taken from Ryan Bates´s railscast #337."

  s.files = Dir["{bin,lib,spec}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]

  s.add_dependency "rails",       "~> 3.2.6"
  # s.add_dependency "capistrano",  "~> 2.12.0" .. doesnt work
  s.add_dependency "capistrano",  "2.9.0"
  
  
  # => Add Test-Dependencies
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "growl"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "database_cleaner"
end
