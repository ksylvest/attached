require 'mocha'
require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  fixtures :all
end
