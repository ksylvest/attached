require 'attached/storage/base'
require 'fog'

module Attached
  module Storage
    class Fog < Base

      attr_reader :defaults

      # Create a new interface supporting save and destroy operations (should be overridden and called).
      def initialize(credentials)
        @defaults = { public: true, metadata: Attached::Attachment.options[:metadata] }
      end

      # Access the host for a storage service (must override).
      #
      # Usage:
      #
      #   storage.host
      def host()
        raise NotImplementedError.new
      end

      # Save a file to a given path.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      def save(file, path)
        file = File.open(file.path)
        directory.files.create(self.options(path).merge(self.defaults.merge(key: path, body: file)))
        file.close
      end

      # Retrieve a file from a given path.
      #
      # Parameters:
      #
      # * path - The path to retrieve.
      def retrieve(path)
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
        directory.files.get(path).destroy if directory.files.head(path)
      end

    private

      def directory
        raise NotImplementedError.new
      end

      def connection
        raise NotImplementedError.new
      end

    end
  end
end
