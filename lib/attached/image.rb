require 'attached/processor'

begin
  require 'rmagick' 
rescue LoadError
  require 'RMagick' 
rescue LoadError
  raise "Installation of 'rmagick' is required before using the 'image' processor"
end

module Attached
  
  class Image < Processor
    
    
    attr_reader :path
    attr_reader :extname

    # Create a processor.
    #
    # Parameters:
    # 
    # * file       - The file to be processed.
    # * options    - The options to be applied to the processing.
    # * attachment - The attachment the processor is being run for.
    
    def initialize(file, options = {}, attachment = nil)
      super
        
      @path     = @file.path
      @extname  = File.extname(@file.path)
    end
    
    
    # Helper function for calling processors.
    #
    # Usage:
    #
    #   self.process
    
    def process
      result = Tempfile.new(["", options['extension'] || self.extname])
      result.binmode
        
      image = ::Magick::Image.read(self.path)
      image_list  = ::Magick::ImageList.new
      
      width, height, operation = self.options[:size].match(/\b(\d*)x?(\d*)\b([\#\<\>])?/)[1..3] if self.options[:size]
      
      width     ||= self.options[:width]
      height    ||= self.options[:height]
      operation ||= self.options[:operation]
      
      width  = width.to_i
      height = height.to_i
      
      image.each do |frame|
        case operation
          when /!/ then puts "hi"
          when /#/ then image_list << frame.resize_to_fill(width, height)
          when /</ then image_list << frame.resize_to_fit(width, height)
          when />/ then image_list << frame.resize_to_fit(width, height)
          else image_list << frame.resize(width, height)
        end
      end
      
      image_list.write(result.path)
      
      return result
    end
    
    
  end
end
