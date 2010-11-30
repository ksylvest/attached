module Attached
  module Storage
    class FS < Base
      
      
      # Create a new file system storage interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   FS.new()
      
      def initialize(credentials = nil)
        credentials = parse(credentials)
      end
      
      
      # Save a file to a given path on a file system.
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      
      def save(file, path)
      end
      
      
      # Destroy a file at a given path on a file system.
      #
      # Parameters:
      #
      # * path - The path to destroy.
      
      def destroy(path)
      end
      
    end
  end
end