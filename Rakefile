# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
begin
  require 'hanna/rdoctask'
rescue
  puts "WARNING: You're missing the hanna gem. RDoc output may not appear as intended. Run 'sudo rake gems:install' in development to install it."
  require 'rake/rdoctask'
end

require 'tasks/rails'
