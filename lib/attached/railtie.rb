require 'attached'
require 'rails'

module Attached

  class Railtie < Rails::Railtie

    rake_tasks do
      load 'tasks/attached.rake'
    end

    initializer 'attached.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :include, Attached
        ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Attached::Definition
      end
    end

  end

end
