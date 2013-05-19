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

        options[:content_type] = case File.extname(path)
        when /tiff/ then "image/tiff"
        when /tif/  then "image/tiff"
        when /jpeg/ then "image/jpeg"
        when /jpe/  then "image/jpeg"
        when /jpg/  then "image/jpeg"
        when /png/  then "image/png"
        when /gif/  then "image/gif"
        when /bmp/  then "image/bmp"
        when /mpeg/ then "video/mpeg"
        when /mpa/  then "video/mpeg"
        when /mpe/  then "video/mpeg"
        when /mpg/  then "video/mpeg"
        when /mov/  then "video/mov"
        when /josn/ then "application/json"
        when /xml/  then "application/xml"
        when /pdf/  then "application/pdf"
        when /rtf/  then "application/rtf"
        when /zip/  then "application/zip"
        when /js/   then "application/js"
        when /html/ then "text/html"
        when /html/ then "text/htm"
        when /txt/  then "text/plain"
        when /csv/  then "text/csv"
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