$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "magic_recipes"
  s.version     = "0.0.1"
  s.authors     = ["torsten wetzel"]
  s.email       = ["torstenwetzel@berlinmagic.com"]
  s.homepage    = "http://berlinmagic.com"
  s.summary     = "MagicRecipes .. some capistrano recipes for our deployment."
  s.description = "Our capistrano recipes for nginx, passenger, thin, private_pub .. some code is taken from Ryan Bates´s railscast #337."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.6"

  s.add_development_dependency "sqlite3"
  
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
