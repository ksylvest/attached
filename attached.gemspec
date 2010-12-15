Gem::Specification.new do |s|
  s.name        = "attached"
  s.version     = "0.1.4"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kevin Sylvestre"]
  s.email       = ["kevin@ksylvest.com"]
  s.homepage    = "http://github.com/ksylvest/attached"
  s.summary     = "An attachment library designed with cloud processors in mind"
  s.description = "Attached is a Ruby on Rails cloud attachment and processor library inspired by Paperclip. Attached lets users push files to the cloud, then perform remote processing on the files."
  s.files       = Dir.glob("{bin,lib}/**/*") + %w(README.rdoc LICENSE Gemfile)
  s.add_dependency 'guid'
  s.add_dependency 'aws-s3'
end

