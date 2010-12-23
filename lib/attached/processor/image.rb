require 'attached/processor/base'

module Attached
  module Processor
    class Image < Base
    
    
      attr_reader :path
      attr_reader :extension
    
      attr_reader :width
      attr_reader :height
      attr_reader :operation
      

      # Create a processor.
      #
      # Parameters:
      # 
      # * file       - The file to be processed.
      # * options    - The options to be applied to the processing.
      # * attachment - The attachment the processor is being run for.
    
      def initialize(file, options = {}, attachment = nil)
        super
        
        @path      = self.file.path
      
        @size      = options[:size]
        @extension = options[:extension]
      
        @width, @height, @operation = @size.match(/(\d*)x?(\d*)(.*)/)[1..3] if @size
      
        @width     ||= options[:width]
        @height    ||= options[:height]
        @operation ||= options[:operation]
      
        @extension ||= File.extname(self.file.path)
      
        @width     = Integer(self.width)
        @height    = Integer(self.height)
      
        raise "Image processor requires specification of 'width' or 'size'"  unless self.width
        raise "Image processor requires specification of 'height' or 'size'" unless self.height
      end
    
    
      # Helper function for calling processors.
      #
      # Usage:
      #
      #   self.process
    
      def process
      
        result = Tempfile.new(["", self.extension])
        result.binmode
      
        begin
        
          parameters = []
        
          parameters << self.path
        
          case operation
          when '#' then parameters << "-resize #{width}x#{height}^ -gravity center -extent #{width}x#{height}"
          when '<' then parameters << "-resize #{width}x#{height}\\<"
          when '>' then parameters << "-resize #{width}x#{height}\\>"
          else          parameters << "-resize #{width}x#{height}"
          end
        
          parameters << result.path
        
          parameters = parameters.join(" ").squeeze(" ")
        
          `convert #{parameters}`
        
          raise "Command 'convert' failed. Ensure file is an image and attachment options are valid." unless $?.exitstatus == 0
        
        rescue Errno::ENOENT  
        
          raise "Command 'convert' not found. Ensure 'Image Magick' is installed."
      
        end
      
        return result
      
      end
      
    end
  end
end
