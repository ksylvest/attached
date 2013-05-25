require 'attached/storage/base'
require 'fog'


module Attached
  module Storage
    class Rackspace < Fog


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
        super

        credentials = parse(credentials)

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


    private


    def directory()
      connection.directories.get(self.container) || connection.directories.create(self.permissions.merge(:key => self.container))
    end


      def connection
        @connection ||= ::Fog::Storage.new(
          :rackspace_username => self.username,
          :rackspace_api_key  => self.api_key,
          :provider => 'Rackspace'
        )
      end


    end
  end
end