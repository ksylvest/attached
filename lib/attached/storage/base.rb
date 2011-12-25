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
      
      
      # Helper for determining options from a file
      #
      # Usage:
      #
      #   options("/images/1.jpg") 
      #   options("/images/1.png")
      #   options("/videos/1.mpg")
      #   options("/videos/1.mov")
      
      def options(path)
        options = {}
        type = File.extname(path)
        
        case type
        when /tiff/ then options[:content_type] = "image/tiff"
        when /tif/  then options[:content_type] = "image/tiff"
        when /jpeg/ then options[:content_type] = "image/jpeg"
        when /jpe/  then options[:content_type] = "image/jpeg"
        when /jpg/  then options[:content_type] = "image/jpeg"
        when /png/  then options[:content_type] = "image/png"
        when /gif/  then options[:content_type] = "image/gif"
        when /bmp/  then options[:content_type] = "image/bmp"
        when /mpeg/ then options[:content_type] = "video/mpeg"
        when /mpa/  then options[:content_type] = "video/mpeg"
        when /mpe/  then options[:content_type] = "video/mpeg"
        when /mpg/  then options[:content_type] = "video/mpeg"
        when /mov/  then options[:content_type] = "video/mov"
        when /josn/ then options[:content_type] = "application/json"
        when /xml/  then options[:content_type] = "application/xml"
        when /pdf/  then options[:content_type] = "application/pdf"
        when /rtf/  then options[:content_type] = "application/rtf"
        when /zip/  then options[:content_type] = "application/zip"
        when /js/   then options[:content_type] = "application/js"
        when /html/ then options[:content_type] = "text/html"
        when /html/ then options[:content_type] = "text/htm"
        when /txt/  then options[:content_type] = "text/plain"
        when /csv/  then options[:content_type] = "text/csv"
        end
        
        return options
      end
      
      
      # Create a new file system storage interface supporting save and destroy operations.
      #
      # Usage:
      #
      #   Base.new()
      
      def initialize(credentials = nil)
        raise NotImplementedError.new
      end
      
      
      # Access the host for a storage service or return null if local.
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
      
      
      # Retrieve a file from a given path.
      #
      # Parameters:
      #
      # * path - The path to retrieve.
      
      def retrieve(path)
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