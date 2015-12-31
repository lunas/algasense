namespace :setup do

  desc "Upload database.yml file."
  task :upload_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/database.yml")), "#{shared_path}/config/database.yml"
    end
  end

  desc "Seed the database."
  task :seed_db do
    on roles(:app) do
      within "#{current_path}" do
        with rails_env: :production do
          execute :rake, "db:seed"
        end
      end
    end
  end

  desc "Symlinks config files for Nginx and Thin."
  task :symlink_config do
    on roles(:app) do
      # no need anymore: execute "rm -f /etc/nginx/sites-enabled/default"

      execute "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/servers/#{fetch(:application)}"

      execute "mkdir -p /usr/local/etc/thin"
      execute "ln -nfs #{current_path}/config/thin.yml /usr/local/etc/thin/algasense.yml"
      #execute "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
    end
  end

end