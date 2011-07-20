default_run_options[:pty] = true

set :application, "tp_theme"
set :repository,  "git@github.com:ctm/tp_theme.git"

set :scm, "git"
set :user, 'ctm'

role :web, "hyou.swcp.com"
role :app, "hyou.swcp.com"
role :db,  "hyou.swcp.com", :primary => true


ssh_options[:forward_agent] = true
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

set :deploy_to, "/users/ctm/apps"


namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # database.yml is never in the source repository, but the one from the
  # previous release should still be current

  task :after_update_code do
    run "cp -p \"#{current_path}/config/database.yml\" \"#{release_path}/config/\""
  end
end
