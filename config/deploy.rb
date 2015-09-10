lock '3.4.0'

set :application, 'demo-rails-capistrano'
set :deploy_user, 'deployer'

# Git configuration
set :repo_url, 'git@github.com:Dockbit/demo-rails-capistrano.git'
set :scm, :git

# SSH settings
set :ssh_options, {
  forward_agent: true,
  port: 22
}

# Rbenv
set :rbenv_type, :user
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_ruby, File.read('.ruby-version').strip

# Misc
set :log_level, :info
set :keep_releases, 5

# Linked application directories
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Application config files
set(:config_files, %w(
  nginx.conf
  unicorn.rb
  unicorn_init.sh
  log_rotation
))

# Application executables
set(:executable_config_files, %w(
  unicorn_init.sh
))

# Linked system files
set(:symlinks, [
  {
    source: 'nginx.conf',
    link: "/etc/nginx/sites-enabled/{{full_app_name}}"
  },
  {
    source: 'unicorn_init.sh',
    link: "/etc/init.d/unicorn_{{full_app_name}}"
  },
  {
    source: 'log_rotation',
    link: "/etc/logrotate.d/{{full_app_name}}"
  }
])

namespace :deploy do
  before :deploy,    'deploy:setup_config'
  after :publishing, 'deploy:restart'
  after :finishing,  'deploy:cleanup'
end
