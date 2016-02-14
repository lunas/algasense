# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'algasense'
set :repo_url, 'https://github.com/lunas/algasense.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/algasense'
set :deploy_user, 'lukasnick'
set :rbenv_ruby, '2.2.3'
set :rbenv_type, :user # or :system, depends on your rbenv setup
#set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} /usr/local/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', '.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:/usr/local/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5


# Sidekiq
set :pty,  false
set :sidekiq_options, {retry: false}
set :sidekiq_monit_use_sudo, false

after 'deploy:publishing', 'thin:restart'

# TODO
# INFO [fbc6ce29] Running /usr/bin/env cd /var/www/algasense/releases/20160107220021; bundle exec thin restart as lukasnick@192.168.88.246
# DEBUG [fbc6ce29] Command: cd /var/www/algasense/releases/20160107220021; bundle exec thin restart
# DEBUG [fbc6ce29] 	bash: bundle: command not found
# --> solution: use same path/prefix for bundle as when capistr. calls it.