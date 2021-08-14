# frozen_string_literal: true

# config valid only for current version of Capistrano
# lock "3.11.0"

set :application, 'ocean-plus-habitats'

set :repo_url, 'https://github.com/unepwcmc/ocean-plus-habitats.git'

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v10.15.1'
set :nvm_map_bins, %w[node npm yarn]

set :deploy_user, 'wcmc'

set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"

# Default value for :scm is :git
set :scm, :git
set :scm_username, 'unepwcmc-read'

set :rvm_type, :user
set :rvm_ruby_version, '2.5.0'

set :ssh_options, {
  forward_agent: true
}

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

set :linked_files, %w[config/database.yml .env]

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/downloads', 'node_modules', 'client/node_modules')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

set :passenger_restart_with_touch, false

namespace :deploy do
  desc 'Delete and recreate records'
  task :import_refresh do
    on roles(:app) do
      invoke 'import:refresh'
    end
  end
end

before 'deploy:publishing', 'deploy:import_refresh'
