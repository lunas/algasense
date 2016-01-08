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



  %w[start stop restart].each do |command|
    desc "#{command} Thin server."
    task command do
      on roles(:app) do
        #execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
        execute "cd #{release_path}; bundle exec thin #{command}"
      end
    end
  end

  before :deploy,   "deploy:check_revision"
  before :deploy, "deploy:upload_secrets"
  after  :deploy,   "deploy:restart"
  after  :rollback, "deploy:restart"

end