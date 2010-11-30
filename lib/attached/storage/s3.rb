module Attached
  module Storage
    class S3 < Base
      
      attr_reader :bucket
      attr_reader :access_key_id
      attr_reader :secret_access_key
      
      
      # Create a new Amazon S3 storage interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   Attached::Storage::S3.new()
      #   Attached::Storage::S3.new("#{Rails.root}/config/s3.yml")
      
      def initialize(credentials = "#{Rails.root}/config/s3.yml")
        credentials = parse(credentials)
        
        @bucket            = credentials[:bucket] || credentials['bucket']
        @access_key_id     = credentials[:access_key_id] || credentials['access_key_id']
        @secret_access_key = credentials[:secret_access_key] || credentials['secret_access_key']
      end
      
      
      # Save a file to a given path on Amazon S3.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      
      def save(file, path)
        connect()
        AWS::S3::S3Object.store(path, file, bucket)
      end
      
      
      # Destroy a file at a given path on Amazon S3.
      #
      # Parameters:
      #
      # * path - The path to destroy.
      
      def destroy(path)
        connect()
        AWS::S3::S3Object.delete(path, bucket)
      end
      
      
      private
      
      
      # Connect to an Amazon S3 server.
      
      def connect
        return AWS::S3::Base.establish_connection!(
          :access_key_id => self.access_key_id, :secret_access_key => self.secret_access_key
        )
      end
      
      
    end
  end
end