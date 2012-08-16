set :default_stage, "staging"
set :stages, %w(staging production)
require 'capistrano/ext/multistage'

require 'bundler/capistrano'

#set :whenever_environment, defer { stage }
#set :whenever_command, "bundle exec whenever"
#require "whenever/capistrano"


default_run_options[:pty] = true
# set :scm, :git
# set :repository,  "git@dev.minerva-group.com:dyr.git" 
set :scm, :git
set :repository, "git@bitbucket.org:globalxolutions/dyr.git"
#set :branch, "master"
set :branch do
  #default_tag = `git tag`.split("\n").last
  #tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  
  tag = Capistrano::CLI.ui.ask "Version / branch to deploy (default 'master'): "
  tag = "master" if tag.empty?
  tag
end
set :deploy_via, :remote_cache

ssh_options[:forward_agent] = true
set :keep_releases, 5

desc "copy *.common.yml to *.yml"
task :copy_common_yamls, :roles => :app do
  run "cp #{shared_path}/config/config.yml" + " #{release_path}/config/config.yml"
  run "cp #{shared_path}/config/database.yml" + " #{release_path}/config/database.yml"
end

desc "precompile the assets"
task :precompile_assets, :roles => :web, :except => { :no_release => true } do
  run "cd #{release_path}; rm -rf public/assets/*"
  run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
end

#namespace :delayed_job do
#  def rails_env
#    fetch(:rails_env, false) ? "RAILS_ENV=#{fetch(:rails_env)}" : ''
#  end
#  
#  desc "Stop the delayed_job process"
#  task :stop, :roles => :app do
#    run "cd #{current_path};#{rails_env} script/delayed_job stop"
#  end
#  
#  desc "Start the delayed_job process"
#  task :start, :roles => :app do
#    run "cd #{current_path};#{rails_env} script/delayed_job start"
#  end
#  
#  desc "Restart the delayed_job process"
#  task :restart, :roles => :app do
#    run "cd #{current_path};#{rails_env} script/delayed_job restart"
#  end
#end

after "deploy:update", "copy_common_yamls"
after "deploy:update", "precompile_assets"
#after "deploy:update", "delayed_job:restart"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end