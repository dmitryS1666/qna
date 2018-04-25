# config valid for current version and patch releases of Capistrano
lock "~> 3.10.2"

set :application, "qna"
set :repo_url, "git@github.com:dmitryS1666/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"
set :format_options, log_file: "log/capistrano.log"

# Default value for :linked_files is []
append :linked_files, "config/database.yml"
append :linked_files, ".env"
# append :linked_files, "public/system"
# append :linked_files, "public/uploads"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end
  task :stop do
    invoke 'unicorn:stop'
  end
  task :start do
    invoke 'unicorn:start'
  end

  after :publishing, :restart
end
