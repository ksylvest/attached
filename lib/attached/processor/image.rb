require 'attached/processor/base'
require 'attached/processor/error'

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
      
        @width     = Integer(self.width)  if self.width
        @height    = Integer(self.height) if self.height
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
        
          if width and height
            case operation
            when '#' then parameters << "-resize #{width}x#{height}^ -gravity center -extent #{width}x#{height}"
            when '<' then parameters << "-resize #{width}x#{height}\\<"
            when '>' then parameters << "-resize #{width}x#{height}\\>"
            else          parameters << "-resize #{width}x#{height}"
            end
          end
          
          parameters << result.path
        
          parameters = parameters.join(" ").squeeze(" ")
        
          `convert #{parameters}`
          
          raise Errno::ENOENT if $?.exitstatus == 127
        
        rescue Errno::ENOENT
          raise "command 'convert' not found: ensure ImageMagick is installed"
        end
        
        unless $?.exitstatus == 0
          raise Attached::Processor::Error, "attachment file must be an image file"
        end
      
        return result
      
      end
      
    end
  end
end
