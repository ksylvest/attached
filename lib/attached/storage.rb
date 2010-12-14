require 'attached/storage/s3'

module Attached
  module Storage
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.medium(s3)
    
    def self.storage(medium = :s3, credentials = nil)
      
      case medium
      when :s3 then return Attached::Storage::S3.new(credentials)
      end
      
    end
    
  end
end