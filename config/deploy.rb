set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'bundler/capistrano'

$:.unshift(File.expand_path("./lib", ENV["rvm_path"]))
require 'rvm/capistrano'
load 'deploy/assets'

set :rvm_ruby_string, 'ruby-1.9.3-p0@localeyes'
set :rvm_type, :user

set :application, "localeyes"
set :repository,  "git@github.com:Cobu/localeyes.git"

set :scm, :git
set :deploy_to, "/var/www/#{application}"
set :deploy_via, :remote_cache
set :user, "deploy"
set :runner, user

set :use_sudo, false

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{deploy_to}/current; ./script/unicorn -E #{rails_env} -D -c config/unicorn.rb"
  end
  task :stop, :roles => :app do
    run "/bin/kill -QUIT `cat /var/www/#{application}/shared/pids/unicorn.pid`"
  end

  task :restart, :roles => :app do
    run "/bin/kill -USR2 `cat /var/www/#{application}/shared/pids/unicorn.pid`"
  end

  desc "Compile asets"
  task :assets do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end

#after "deploy:update_code", "deploy:migrate"
#before :"deploy:symlink", :"deploy:assets"



