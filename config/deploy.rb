set :application, 'bittorious'
set :repo_url, 'git@github.com:preston/bittorious.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true
set :passenger_restart_with_sudo, true

set :linked_files, %w{config/database.yml config/initializers/devise.rb config/initializers/smtp.rb}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/data}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 3

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
