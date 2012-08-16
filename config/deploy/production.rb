set :rails_env, "production"
set :rack_env, "production"

set :application, "dyr"

# set :location, "23.23.226.128"
set :server1, "dyr_1"
# set :server2, "dyr_2"
# set :server3, "dyr_3"
# set :server4, "dyr_4"
# set :server5, "dyr_5"
role :web, server1#, server2, server3, server4, server5
role :app, server1#, server2, server3, server4, server5
role :db,  server1, :primary => true

set :deploy_to, "/var/www/#{application}"

set :user, 'passenger'
set :runner, 'passenger'
set :spinner, false
set :deploy_via, :export

desc "Restart Passenger Phusion"
task :restart, :roles => :app do
  run "touch #{current_path}/tmp/restart.txt"
end

after "deploy:update", "deploy:migrate"
after "deploy:update", "restart"