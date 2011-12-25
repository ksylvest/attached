module Attached
  module Processor
    class Base
      
      
      attr_accessor :file
      attr_accessor :options
      attr_accessor :attachment
    
    
      # Create and run a processor.
      #
      # Parameters:
      # 
      # * file       - The file to be processed.
      # * options    - The options to be applied to the processing.
      # * attachment - The attachment the processor is being run for.

      def self.process(file, options = {}, attachment = nil)
        new(file, options, attachment).process
      end
    
    
      # Create a processor.
      #
      # Parameters:
      # 
      # * file       - The file to be processed.
      # * options    - The options to be applied to the processing.
      # * attachment - The attachment the processor is being run for.

      def initialize(file, options = {}, attachment = nil)
        @file = file
        @options = options
        @attachment = attachment
      end
    
    
      # Run the processor. 

      def process
        raise NotImplementedError.new   
      end
    
    
    end
  end
end
