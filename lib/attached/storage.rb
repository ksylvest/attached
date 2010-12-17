require 'attached/storage/aws'

module Attached
  module Storage
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.medium(aws)
    
    def self.storage(medium = :aws, credentials = nil)
      
      case medium
      when :aws then return Attached::Storage::AWS.new(credentials)
      end
      
    end
    
  end
end