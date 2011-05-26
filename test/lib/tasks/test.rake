namespace :test do
  
  desc "Runs test under a given 'attached' environment"
  task :env, [:attached] do |t, args|
    ENV['ATTACHED'] = args[:attached]
    Rake::Task["test"].execute
  end
  
end