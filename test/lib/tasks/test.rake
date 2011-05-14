namespace :test do
  
  desc "Runs test under a given 'attached' environment"
  task :env, :attached, :needs => :environment do |t, args|
    ENV['ATTACHED'] = args[:attached]
    Rake::Task["test"].execute
  end
  
end