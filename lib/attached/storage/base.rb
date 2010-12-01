require 'attached/storage/base'

module Attached
  module Storage
    class Base
      
      
      # Helper for parsing credentials from a hash, file, or string.
      #
      # Usage:
      #
      #   parse({...}) 
      #   parse(File.open(...))
      #   Parse("...")
      
      def parse(credentials)
        case credentials
        when Hash    then credentials
        when File    then YAML::load(credentials)[Rails.env]
        when String  then YAML::load(File.read(credentials))[Rails.env]
        else raise ArgumentError.new("credentials must be a hash, file, or string")
        end
      end
      
      
      # Create a new file system storage interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   Base.new()
      
      def initialize(credentials = nil)
        raise NotImplementedError.new
      end
      
      
      # Access the host (e.g. localhost:3000) for a storage service.
      #
      # Usage:
      #
      #   storage.host
      
      def host()
        raise NotImplementedError.new
      end
      
      
      # Save a file to a given path (abstract).
      #
      # Parameters:
      #
      # * file - The file to save.
      # * path - The path to save.
      
      def save(file, path)
        raise NotImplementedError.new
      end
      
      
      # Destroy a file at a given path (abstract).
      #
      # Parameters:
      #
      # * path - The path to destroy.
      
      def destroy(path)
        raise NotImplementedError.new
      end
      
    end
  end
end