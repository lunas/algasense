namespace :deploy do

  desc "Makes sure local git is in sync with remote."
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end


  desc "Upload config/secrets.yml."
  task :upload_secrets do
    on roles(:app) do
      upload! StringIO.new(File.read("config/secrets.yml")), "#{shared_path}/config/secrets.yml"
    end
  end


  namespace :thin do

    desc "Stop Thin"
    task :stop do
      on roles(:app) do
        pidfile = "#{release_path}/tmp/pids/thin.pid"
        #if test("[ -f #{pidfile} ]")
          execute "cd #{release_path}; RBENV_ROOT=~/.rbenv RBENV_VERSION=2.2.3 /usr/local/bin/rbenv exec bundle exec thin stop"
        #end
      end
    end


    desc "Start Thin"
    task :start do
      on roles(:app) do
        pid_file = "#{release_path}/tmp/pids/thin.pid"
        #if test("[ -f #{pid_file} ]")
        #  raise "Refuse to start Thin, pidfile already exists: #{pid_file}."
        #else
          config_file = "#{release_path}/config/thin/#{fetch(:rails_env)}.yml"
          execute "cd #{release_path}; RBENV_ROOT=~/.rbenv RBENV_VERSION=2.2.3 /usr/local/bin/rbenv exec bundle exec thin start -C #{config_file}"
        #end
      end
    end

  end


  before :deploy,   "deploy:check_revision"
  before :deploy,   "deploy:upload_secrets"

  #after  :deploy,   "deploy:thin:stop"
  #after  :deploy,   "deploy:thin:start"

  #after  :rollback, "deploy:thin:stop"
  #after  :rollback, "deploy:thin:start"
end