require 'attached/storage/base'

require 'aws/s3'


module Attached
	module Storage
		class S3 < Base
			
			
			attr_reader :bucket
			attr_reader :access_key_id
			attr_reader :secret_access_key
			
			
			# Create a new AWS interface supporting save and destroy operations.
			#
			# Usage:
			#
			#		Attached::Storage::S3.new()
			#		Attached::Storage::S3.new("s3.yml")
			
			def initialize(credentials)
				credentials = parse(credentials)
				
				@bucket						 = credentials[:bucket]            || credentials['bucket']
				@access_key_id		 = credentials[:access_key_id]     || credentials['access_key_id']
				@secret_access_key = credentials[:secret_access_key] || credentials['secret_access_key']
			end
			
			
			# Access the host (e.g. bucket.s3.amazonaws.com) for a storage service.
			#
			# Usage:
			#
			#		storage.host
			
			def host()
				"https://#{self.bucket}.s3.amazonaws.com"
			end
			
			
      # Save a file to a given path on AWS S3.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      
      def save(file, path)
        connect()
        begin
          AWS::S3::S3Object.store(path, file, bucket, :access => :authenticated_read)
        rescue AWS::S3::NoSuchBucket => e
  			  AWS::S3::Bucket.create(bucket)
          retry
        end
      end
      
      
      # Destroy a file at a given path on AWS S3.
      #
      # Parameters:
      #
      # * path - The path to destroy.
      
      def destroy(path)
        connect()
        begin
          AWS::S3::S3Object.delete(path, bucket, :access => :authenticated_read)
        rescue AWS::S3::NoSuchBucket => e
  			  AWS::S3::Bucket.create(bucket)
          retry
        end
      end
			
			
		private
			
			
			# Connect to an AWS S3 server.
			
			def connect()
        @connection ||= AWS::S3::Base.establish_connection!(
          :access_key_id => access_key_id, :secret_access_key => secret_access_key
        )
			end
			
			
		end
	end
end