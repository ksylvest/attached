require 'attached/storage/base'
require 'attached/storage/fs'
require 'attached/storage/s3'

module Attached
  module Storage
    
    def self.medium(storage, credentials = nil)
      
      case storage
      when :fs then return Attached::Storage::FS.new()
      when :s3 then return Attached::Storage::S3.new()
      end
      
    end
    
  end
end