require 'capistrano_colors'
require 'bundler/capistrano'

# Load RVM's capistrano plugin.
require 'rvm/capistrano'

require 'capistrano-db-tasks'

set :db_local_clean, true
set :locals_rails_env, 'development'

ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true

set :rvm_ruby_string, 'ruby-2.4.2@hg'

servers = ['hg.sephplus.com']

# set servers
role :web do servers end

set :servers, servers
role :db, :primary => true do servers end

set :rails_env, 'production'
set :branch, 'master'

# == rvm setting
set :rvm_type, :system
# ==

# == bundler setting
set :bundle_flags, "--deployment"
set :bundle_without, [:development, :test]
# ==

set :application, "hg"
set :deploy_to,   "/var/www/#{application}"
set :repository,  "git@gitlab.sephplus.com:sephplus/hg.git"

set :scm, :git
set :user, "www-data"

set :use_sudo, false
set :deploy_via, :remote_cache
set :default_run_options, :pty => true


set :deploy_env, 'production'
set :rails_env, 'production'

set :database_yml, "database.yml"
set :current_rev, `git show --format='%H' -s`.chomp

# == for Unicorn restart
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  task :restart, :roles => [:web], :except => { :no_release => true } do
    run "kill `cat /var/www/hg/shared/pids/hg.pid` || true"
  end

  task :reload, :roles => [:web], :except => { :no_release => true } do
    run "kill -HUP `cat /var/www/hg/shared/pids/hg.pid` || true"
  end

  task :precompile do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile --trace"
  end

  task :reindex do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end
# =

# == add symlink
after "bundle:install", :roles => :web do
  run "ln -s #{shared_path}/config/#{database_yml} #{release_path}/config/database.yml"
  
  # run "cd #{release_path}l RAILS_ENV=production bundle exec rails db:environment:set"
  run "cd #{release_path}; RAILS_ENV=production bundle exec rails db:create --trace"
end

after "bundle:install", "deploy:migrate"

after 'deploy:update', 'deploy:cleanup'

after "deploy:cleanup", "deploy:precompile"


# namespace :deploy do
#   desc "capistrano seed"
#   task :seed do
#     run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
#   end
# end