#!/usr/bin/env rake

require 'appraisal'

require 'bundler'

require 'rake/testtask'

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test
