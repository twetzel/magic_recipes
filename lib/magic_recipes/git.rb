# encoding: utf-8
module MagicRecipes
  module Rvm
    def self.load_into(configuration)
      configuration.load do
        
        
        set_default :git_usr, "gitusr"
        set_default :git_pwd, "gitpwd"
        
        namespace :git do
          
          # Restart Passenger
          desc "avoid Username and Passwort input twice"
          task :private do
            # should start git_cap localy
            if git_usr && git_usr != "gitusr" && git_pwd && git_pwd != "gitpwd"
              run system( "../../../bin/git_cap #{git_usr} #{git_pwd}" )
            end
            # %x()
          end
          
        end
        
        # eof
        
      end
    end
  end
end

