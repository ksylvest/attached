require 'attached/processor/base'
require 'attached/processor/audio'
require 'attached/processor/image'

module Attached
  module Processor
    
    
    # Create a storage object given a medium and credentials.
    #
    # Usage:
    #
    #   Attached::Processor.processor(:audio)
    #   Attached::Processor.processor(:image)
    #   Attached::Processor.processor(Attached::Processor::Video)
    
    def self.processor(processor)
      
      return processor if processor.is_a? Attached::Processor::Base
      
      case processor
        when :audio then return Attached::Processor::Audio
        when :image then return Attached::Processor::Image
      end
      
      raise "undefined processor '#{processor}'"
      
    end
    
    
  end
end