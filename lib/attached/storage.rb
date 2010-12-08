require 'attached/storage/s3'

module Attached
  module Storage
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.medium(s3)
    
    def self.medium(storage = :s3, credentials = nil)
      
      case storage
      when :s3 then return Attached::Storage::S3.new(credentials)
      end
      
    end
    
  end
end