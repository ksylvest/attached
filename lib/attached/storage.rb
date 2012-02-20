require 'attached/storage/base'
require 'attached/storage/aws'
require 'attached/storage/google'
require 'attached/storage/rackspace'
require 'attached/storage/local'

module Attached
  module Storage


    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.storage(:local)
    #   Attached::Storage.storage(:aws,       "#{Rails.root}/config/aws.yml"      )
    #   Attached::Storage.storage(:google,    "#{Rails.root}/config/google.yml"   )
    #   Attached::Storage.storage(:rackspace, "#{Rails.root}/config/rackspace.yml")
    #   Attached::Storage.storage(Attached::Storage::Custom.new)

    def self.storage(storage, credentials)

      return storage if storage.is_a? Attached::Storage::Base

      case storage
        when :aws       then return Attached::Storage::AWS.new       credentials
        when :google    then return Attached::Storage::Google.new    credentials
        when :rackspace then return Attached::Storage::Rackspace.new credentials
        when :local     then return Attached::Storage::Local.new
        else raise "undefined storage '#{storage}'"
      end

    end


  end
end