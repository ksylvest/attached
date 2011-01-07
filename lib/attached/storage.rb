require 'attached/storage/aws'
require 'attached/storage/google'
require 'attached/storage/rackspace'

module Attached
  module Storage
    
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.storage(:aws)
    #   Attached::Storage.storage(:google)
    #   Attached::Storage.storage(:rackspace)
    
    def self.storage(medium = :aws, credentials = nil)
      
      case medium
        when :aws       then return Attached::Storage::AWS.new       credentials
        when :google    then return Attached::Storage::Google.new    credentials
        when :rackspace then return Attached::Storage::Rackspace.new credentials
        else raise "undefined storage medium '#{medium}'"
      end
      
    end
    
    
  end
end