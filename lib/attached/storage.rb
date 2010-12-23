require 'attached/storage/base'
require 'attached/storage/aws'

module Attached
  module Storage
    
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.storage()
    #   Attached::Storage.storage(:aws)
    #   Attached::Storage.storage(:aws, credentials)
    
    def self.storage(medium = :aws, credentials = nil)
      
      case medium
        when :aws then return Attached::Storage::AWS.new credentials
        else raise "undefined storage medium '#{medium}'"
      end
      
    end
    
    
  end
end