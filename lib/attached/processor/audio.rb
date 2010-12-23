require 'attached/processor/base'

module Attached
  module Processor
    class Audio < Base
    
    
      attr_reader :path
      attr_reader :extension
      attr_reader :preset
      

      # Create a processor.
      #
      # Parameters:
      # 
      # * file       - The file to be processed.
      # * options    - The options to be applied to the processing.
      # * attachment - The attachment the processor is being run for.
    
      def initialize(file, options = {}, attachment = nil)
        super
        
        @preset    = options[:preset]
        @path      = self.file.path
        
        @extension = options[:extension]
        
        @extension ||= File.extname(self.file.path)
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
          
          parameters << "--preset #{self.preset}" if self.preset
      
          paramaters << self.path
          parameters << result.path
        
          parameters = parameters.join(" ").squeeze(" ")
        
          `lame #{parameters}`
        
          raise "Command 'lame' failed. Ensure file is an audio and attachment options are valid." unless $?.exitstatus == 0
        
        rescue Errno::ENOENT  
        
          raise "Command 'lame' not found. Ensure 'LAME' is installed."
      
        end
      
        return result
      
      end
    
    end
  end
end
