require 'attached'
require 'rails'

module Attached
  class Railtie < Rails::Railtie
    initializer 'attached.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :include, Attached
      end
    end
  end
end