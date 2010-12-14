module Attached

  class Processor
    
    
    attr_accessor :file
    attr_accessor :options
    attr_accessor :attachment
    
    
    # Create and execute a processor.
    #
    # Parameters:
    # 
    # * file       - The file to be processed
    # * options    - The options to be applied to the processing.
    # * attachment - The attachment the processor is being execute on.

    def self.process(file, options = {}, attachment = nil)
      new(file, options, attachment).execute
    end
    
    
    # Create a processor.
    #
    # Parameters:
    # 
    # * file       - The file to be processed
    # * options    - The options to be applied to the processing.
    # * attachment - The attachment the processor is being execute on.

    def initialize(file, options = {}, attachment = nil)
      @file = file
      @options = options
      @attachment = attachment
    end
    
    
    # Execute the processor. 

    def process
      raise NotImplementedError.new   
    end
    
    
  end

end
