require 'bundler/capistrano'
$:.unshift(File.expand_path('./lib', ENV['/home/deploy/.rvm/bin']))

# Load RVM's capistrano plugin.
#require "rvm/capistrano"

set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user
set :application, "styckrparty"

# repo details
set :scm, :git
set :branch, "master"
set :repository, "git@github.com:AcapellaMedia/StyxRyvrRebuild.git"


set :user, "deploy"
set :use_sudo, false

set :deploy_to, "/home/deploy/apps/#{application}"
set :deploy_via, :remote_cache

role :web, "69.164.203.69" # Your HTTP server, Apache/etc
role :app, "69.164.203.69" # This may be the same as your `Web` server
role :db, "69.164.203.69", :primary => true # This is where Rails migrations will run


# server details
ssh_options[:forward_agent] = true


# runtime dependencies
# tasks
namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
    run "ln -nfs #{shared_path}/db/development.sqlite3 #{release_path}/db/development.sqlite3"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'


