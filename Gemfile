source 'http://rubygems.org'

gemspec

gem 'rails'

gem 'jquery-rails'

gem 'sqlite3'

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
