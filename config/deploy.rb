# RVM Stuff...

require 'rvm/capistrano'
require 'bundler/capistrano'

set :rails_env,             'production'
set :rvm_type,              :system
set :rvm_ruby_string,       "ruby-2.0.0"
set :rvm_path,              "/usr/local/rvm"


set :stages, %w(production uat appliance)
set :default_stage, "appliance"
set :application, "bittorious"
set :rake, "#{rake} --trace"


# set :bundle_flags, "--binstubs"

# TGen Cloud
role :web, "uat.bittorious.com"                          # Your HTTP server, Apache/etc
role :app, "uat.bittorious.com"                          # This may be the same as your `Web` server
role :db,  "uat.bittorious.com", :primary => true # This is where Rails migrations will run


set :user, "torrent"
set :group, "torrent"

set :scm, :git
# Not working. 
# set :repository, "ssh://git@10.55.3.107:7999/bit/tater.git"
set :repository, "git@github.com:tgen/tater.git"
set :deploy_to, "/var/www/#{application}"
set :deploy_env, 'appliance'


set :use_sudo,    false
set :deploy_via, 'copy'
set :copy_exclude, ['.git']
set :user,      "www-data"

after "deploy", "deploy:migrate"
before "deploy:assets:precompile", "config:update"
before "bundle:install", "rvm:trust_rvmrc"


ssh_options[:forward_agent] = true
default_run_options[:pty] = true


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
  run "touch #{release_path}/tmp/restart.txt"
 
  end
end


namespace :rvm do
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
end


# Custom stuff.
namespace :config do
 
  desc "Add server-only shared directories."
  task :setup, :roles => [:app] do
    run "mkdir -p #{shared_path}/config"
  end
  after "deploy:setup", "config:setup"
  
  desc "Update server-only config files to new deployment directory."
  task :update, :roles => [:app] do
  	run "cp -Rfv #{shared_path}/config #{release_path}"
    # run "cp -Rfv #{shared_path}/public/data #{release_path}/public/"
		run "ln -s #{shared_path}/public/data #{release_path}/public/data"
  end
end