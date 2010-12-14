require 'attached/processor'

require 'rmagick'

module Attached
  
  class Image < Processor
    
    
    attr_reader :path
    attr_reader :extname
    attr_reader :basename

    
    def initialize(file, options = {}, attachment = nil)
      super
        
      @path     = @file.path
      @extname  = File.extname(@file.path)
      @basename = File.basename(@file.path, @extname)
    end
    
    
    def process
      result = Tempfile.new("#{self.basename}#{self.extname}")
      result.binmode
      
      begin
        image = ::Magick::Image.read(self.path).first
        image_list  = ::Magick::ImageList.new
        
        width, height, operation = self.options[:size].match(/\b(\d*)x?(\d*)\b([\#\<\>])?/)[1..3] if self.options[:size]
        
        width     ||= self.options[:width]
        height    ||= self.options[:height]
        operation ||= self.options[:operation]
        
        width = width.to_i
        height = height.to_i
        
        image.resize_to_fill!(width, height)
        
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
        
      rescue ::Magick::ImageMagickError => e
        raise "Processing failed."
      end
      
      return result
    end
    
  end
end
