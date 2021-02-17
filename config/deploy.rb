# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock "~> 3.13.0"

set :pty, true
set :application, "typhoon"
set :repo_url, "git@github.com:bukalapak/typhoon.git"

# Default branch is :master
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/your_home_server/typhoon"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Set rbenv
set :rbenv_type, :user
set :rbenv_ruby, "2.6.3"

# Set secret
set :linked_files, %w{config/master.key config/database.yml .env}
set :linked_dirs, %w{tmp/pids tmp/sockets log storage}

# Puma init ActiveRecord
set :puma_init_active_record, true
set :puma_nginx, :app

# Database Migration role
set :migration_role, :app

# Whenever Update Cron
set :whenever_roles, -> { :app }
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
