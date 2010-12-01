require 'attached/storage/base'
require 'attached/storage/fs'
require 'attached/storage/s3'

module Attached
  module Storage
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Storage.medium(:fs)
    #   Attached::Storage.medium(:s3)
    
    def self.medium(storage = :fs, credentials = nil)
      
      case storage
      when :fs then return Attached::Storage::FS.new(credentials)
      when :s3 then return Attached::Storage::S3.new(credentials)
      end
      
    end
    
  end
end