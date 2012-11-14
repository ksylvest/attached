source 'http://rubygems.org'

gemspec

gem 'rails'

group :assets do
  gem 'sass-rails', '3.2.5'
  gem 'coffee-rails', '3.2.2'
end

gem 'haml-rails'
gem 'jquery-rails'
gem 'bootstrap-sass'

group :test do
  gem 'minitest'
  gem 'turn', :require => false
end

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbcmysql-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
end
