require 'attached/storage/base'
require 'fog'


module Attached
  module Storage
    class AWS < Base


      attr_reader :permissions

      attr_reader :bucket
      attr_reader :access_key_id
      attr_reader :secret_access_key


      # Create a new interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   Attached::Storage::AWS.new()
      #   Attached::Storage::AWS.new("aws.yml")

      def initialize(credentials)
        credentials = parse(credentials)

        @permissions       = { :public => true }

        @bucket            = credentials[:bucket]            || credentials['bucket']
        @access_key_id     = credentials[:access_key_id]     || credentials['access_key_id']
        @secret_access_key = credentials[:secret_access_key] || credentials['secret_access_key']

        raise "'bucket' must be specified if using 'aws' for storage" unless @bucket
      end


      # Access the host (e.g. bucket.s3.amazonaws.com) for a storage service.
      #
      # Usage:
      #
      #   storage.host

      def host()
        "https://#{self.bucket}.s3.amazonaws.com/"
      end


      # Save a file to a given path.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.

      def save(file, path)
        file = File.open(file.path)

        directory = connection.directories.get(self.bucket)
        directory || connection.directories.create(self.permissions.merge(:key => self.bucket))

        directory.files.create(self.options(path).merge(self.permissions.merge(:key => path, :body => file)))

        file.close
      end


      # Retrieve a file from a given path.
      #
      # Parameters:
      #
      # * path - The path to retrieve.

      def retrieve(path)
        directory = connection.directories.get(self.bucket)
        directory ||= connection.directories.create(self.permissions.merge(:key => self.bucket))

        file = directory.files.get(path)

        body = file.body

        extname = File.extname(path)
        basename = File.basename(path, extname)

        file = Tempfile.new([basename, extname])
        file.binmode
        file.write(body)
        file.rewind

        file
      end


      # Destroy a file at a given path.
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
          :aws_secret_access_key => self.secret_access_key,
          :aws_access_key_id     => self.access_key_id,
          :provider => 'AWS'
        )
      end


    end
  end
end