require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :test

desc 'run specs, simplecov and rubocop'
task :test do
  raise 'FAILURE: Failing specs or incomplete coverage!' unless system 'rspec'
  raise 'FAILURE: Rubocop violations!' unless system 'rubocop'
end
