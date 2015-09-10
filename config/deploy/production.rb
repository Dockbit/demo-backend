set :stage, :production
set :branch, 'master'
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :host_name, 'demo-rails-capistrano.dockbit.com'

server fetch(:host_name), user: fetch(:deploy_user), roles: %w{ web app db }, primary: true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :rails_env, :production

set :unicorn_worker_count, 4
set :enable_ssl, false
