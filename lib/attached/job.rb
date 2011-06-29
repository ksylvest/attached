module Attached
  class Job
    @queue = :attached
    
    def self.perform(klass, id, method)
      object = klass.find(id)
      attachment = object.send(method)
      attachment.reprocess!
    end
    
  end
end