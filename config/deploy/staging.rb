# $:.unshift(File.expand_path("~/.rvm/lib")) # Add RVM's lib directory to the load path.
# require "rvm/capistrano"                  # Load RVM's capistrano plugin.
# set :rvm_ruby_string, 'ree-1.8.7-2012.02@dyr'        # Or whatever env you want it to run in.
# set :rvm_type, :user

set :rails_env, "staging"
set :rack_env, "staging"

set :application, "dyr"
set :location, "staging"
role :web, location
role :app, location
role :db,  location, :primary => true


set :deploy_to, "/var/www/#{application}"

set :user, 'passenger'
set :runner, 'passenger'
set :spinner, false
set :deploy_via, :export
set :keep_releases, 10

set :use_sudo, false

desc "Restart Passenger Phusion"
task :restart, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end

after "deploy:update", "deploy:migrate"
after "deploy:update", "restart"
after "deploy:migrate", "deploy:cleanup"