require 'attached/storage/fog'

module Attached
  module Storage
    class Google < Fog

      attr_reader :bucket
      attr_reader :access_key_id
      attr_reader :secret_access_key

      # Create a new interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   Attached::Storage::Google.new()
      #   Attached::Storage::Google.new("google.yml")
      def initialize(credentials)
        super
        credentials = parse(credentials)

        @bucket            = credentials[:bucket]            || credentials['bucket']
        @access_key_id     = credentials[:access_key_id]     || credentials['access_key_id']
        @secret_access_key = credentials[:secret_access_key] || credentials['secret_access_key']
        raise "'bucket' must be specified if using 'google' for storage" unless @bucket
      end

      # Access the host (e.g. https://attached.commondatastorage.googleapis.com/) for a storage service.
      #
      # Usage:
      #
      #   storage.host
      def host()
        "https://#{self.bucket}.commondatastorage.googleapis.com/"
      end

    private

      def directory()
        connection.directories.get(self.bucket) || connection.directories.create(self.defaults.merge(key: self.bucket))
      end

      def connection
        @connection ||= ::Fog::Storage.new(
          google_storage_secret_access_key: self.secret_access_key,
          google_storage_access_key_id: self.access_key_id,
          provider: 'Google'
        )
      end

    end
  end
end
