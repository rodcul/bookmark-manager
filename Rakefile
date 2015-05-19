require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'cucumber/rake/task'

RuboCop::RakeTask.new :cop
RSpec::Core::RakeTask.new :spec
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task default: [:cop, :spec, :features]
