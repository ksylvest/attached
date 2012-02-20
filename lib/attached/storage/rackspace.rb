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


      # Create a new interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   Attached::Storage::Rackspace.new()
      #   Attached::Storage::Rackspace.new("rackspace.yml")

      def initialize(credentials)
        credentials = parse(credentials)

        @permissions  = { :public => true }

        @container    = credentials[:container] || credentials['container']
        @username     = credentials[:username]  || credentials['username']
        @api_key      = credentials[:api_key]   || credentials['api_key']

        raise "'container' must be specified if using 'rackspace' for storage" unless @container
      end


      # Access the host (e.g. https://storage.clouddrive.com/container) for a storage service.
      #
      # Usage:
      #
      #   storage.host

      def host()
        "https://storage.clouddrive.com/#{self.container}/"
      end


      # Save a file to a given path.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.

      def save(file, path)
        file = File.open(file.path)

        directory = connection.directories.get(self.container)
        directory ||= connection.directories.create(self.permissions.merge(:key => self.container))

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
        directory = connection.directories.get(self.container)
        directory ||= connection.directories.create(self.permissions.merge(:key => self.container))

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