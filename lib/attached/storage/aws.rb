require 'attached/storage/fog'
require 'fog'


module Attached
  module Storage
    class AWS < Fog


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
        super

        credentials = parse(credentials)

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


    private


    def directory()
      connection.directories.get(self.bucket) || connection.directories.create(self.defaults.merge(:key => self.bucket))
    end


      def connection
        @connection ||= ::Fog::Storage.new(
          :aws_secret_access_key => self.secret_access_key,
          :aws_access_key_id     => self.access_key_id,
          :provider => 'AWS'
        )
      end


    end
  end
end
