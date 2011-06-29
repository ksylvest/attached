require "resque/tasks"

namespace :resque do
  task setup: :environment do
    ENV['QUEUE'] ||= '*'
  end
end

namespace :jobs do
  task work: "resque:work"
end