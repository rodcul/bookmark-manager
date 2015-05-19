require 'data_mapper'

task :before do
  fail "RAKE_ENV has not been specified" unless ENV.key?('RACK_ENV')
end

namespace :db do
  desc "do it on test"
  task :test do
    ENV['RACK_ENV'] = 'test'
  end

  desc "do it on development"
  task :development do
    ENV['RACK_ENV'] = 'development'
  end
end

desc "Non destructive upgrade"
task auto_upgrade: [:before] do
  # auto_upgrade makes non-destructive changes.
  # If your tables don't exist, they will be created
  # but if they do and you changed your schema
  # (e.g. changed the type of one of the properties)
  # they will not be upgraded because that'd lead to data loss.

  require './app/data_mapper_setup'
  DataMapper.auto_upgrade!
  puts "Auto-upgrade complete (no data loss)"
end

desc "Destructive upgrade"
task auto_migrate: [:before] do
  # To force the creation of all tables as they are
  # described in your models, even if this
  # leads to data loss, use auto_migrate:

  require './app/data_mapper_setup'
  DataMapper.auto_migrate!
  puts "Auto-migrate complete (data was lost)"
end
# Finally, don't forget that before you do any of that stuff,
# you need to create a database first.

task :test do
  system "rspec 2>/dev/null"
end
