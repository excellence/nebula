set :application, "nebula"
set :user, "nebula"
set :deploy_to, "/home/nebula"
set :run_method, :run

set :repository,  "git://github.com/excellence/nebula.git"
set :scm, :git
set :branch, "develop"
set :deploy_via, :remote_cache


role :web, "dsander.de"                          # Your HTTP server, Apache/etc
role :app, "dsander.de"                          # This may be the same as your `Web` server
role :db,  "dsander.de", :primary => true # This is where Rails migrations will run

namespace :deploy do
  desc "Migrate before restart"
  task :before_restart do
    copy_in_database_config
    migrate
  end
  desc "Copies in database.yml from the root"
  task :copy_in_database_config do
    run "cp /home/nebula/database.yml #{current_path}/config/database.yml"
  end


  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'vendor_bundle')
    release_dir = File.join(current_release, 'vendor/bundle')
    run("mkdir -p #{shared_dir} && ln -s #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    run "cd #{release_path} && bundle install --deployment --without test"
  end
end
 
after 'deploy:update_code', 'bundler:bundle_new_release'