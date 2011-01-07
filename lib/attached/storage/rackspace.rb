require 'attached/storage/base'

begin
  require 'fog'
rescue LoadError
  raise "installation of 'fog' is required before using 'rackspace' for storage"
end


module Attached
	module Storage
		class Rackspace < Base
			
			
			attr_reader :permissions
			attr_reader :container
			attr_reader :username
			attr_reader :api_key
			
			
			# Create a new AWS interface supporting save and destroy operations.
			#
			# Usage:
			#
			#		Attached::Storage::Rackspace.new()
			#		Attached::Storage::Rackspace.new("rackspace.yml")
			
			def initialize(credentials)
				credentials = parse(credentials)
				
				@permissions  = { :public => true }
				
				@container		= credentials[:container] || credentials['container']
				@username     = credentials[:username]  || credentials['username']
				@api_key      = credentials[:api_key]   || credentials['api_key']
			end
			
			
			# Access the host (e.g. bucket.s3.amazonaws.com) for a storage service.
			#
			# Usage:
			#
			#		storage.host
			
			def host()
				"https://#{self.bucket}.s3.amazonaws.com/"
			end
			
			
      # Save a file to a given path on AWS S3.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      
      def save(file, path)
        file = File.open(file.path)
        
        directory = connection.directories.get(self.bucket)
        directory ||= connection.directories.create(self.permissions.merge(:key => self.bucket))
        
        directory.files.create(self.permissions.merge(:body => file, :key => path))
      end
      
      
      # Destroy a file at a given path on AWS S3.
      #
      # Parameters:
      #
      # * path - The path to destroy.
      
      def destroy(path)
        directory = connection.directories.get(self.bucket)
        directory ||= connection.directories.create(self.permissions.merge(:key => self.bucket))
        
        file = directory.files.get(path)
        file.destroy if file
      end
			
			
		private

			
			def connection
			  @connection ||= Fog::Storage.new(
          :rackspace_username => self.username,
          :rackspace_api_key  => self.api_key,
          :provider => 'Rackspace'
        )
			end
			
			
		end
	end
end