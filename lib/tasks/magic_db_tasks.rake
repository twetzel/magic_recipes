namespace :db do
  namespace :stuff do
 
    desc "dump the tables holding seed data to db/RAILS_ENV_seed.sql. SEED_TABLES need to be defined in config/environment.rb!!!"
    task :dump => :environment do
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      dump_cmd = "mysqldump --user=#{config['username']} --password=#{config['password']} #{config['database']} #{SEED_TABLES.join(" ")} > db/#{RAILS_ENV}_data.sql"
      system(dump_cmd)
    end
    
    desc "load the dumped seed data from db/development_seed.sql into the test database"
    task :load => :environment do
      config = ActiveRecord::Base.configurations[RAILS_ENV]
      system("mysql --user=#{config['username']} --password=#{config['password']} #{config['database']} < db/#{RAILS_ENV}_data.sql")
     end
 
    desc "load the dumped seed data from db/development_seed.sql into the test database"
    task :testload => :environment do
      config = ActiveRecord::Base.configurations['test']
      system("mysql --user=#{config['username']} --password=#{config['password']} #{config['database']} < db/test_data.sql")
     end
     
    desc "drop the dumped seed data from db/development_seed.sql into the test database"
    task :drop => :environment do
      ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }
     end

  end
end