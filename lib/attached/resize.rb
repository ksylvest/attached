require 'attached/processor'

module Attached
  
  class Resize < Processor
    
    
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
      puts "Attached::Resize.process"
      
      return self.file
    end
    
    
  end
end
